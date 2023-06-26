extends Node

var mouse_sens := 1.0
var collected := 0
var is_interacting := false
var has_flashlight := false
var stamina := max_stamina
var stamina_cooldown := 1.0

var player_pos
var thread : Thread

const max_stamina := 10000

const notifNode := preload("res://src/notification/notification.tscn")
const GAME := preload("res://src/world/game.tscn")
const MAP_1 := "res://src/world/floor_1.tscn"
const MAP_2 := "res://src/world/floor_2.tscn"
var next_map = MAP_1

signal all_collected()
signal stamina_reached_zero()

func _ready():
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	thread = Thread.new()
	thread.start(_thread_function_, Thread.PRIORITY_NORMAL)
	

func notif(text: String, duration: float = 2.5):
	# checks if there are notication nodes
	while get_node("/root/Game/Notification_Container").get_child_count() != 0:
		# waits before checking again and loops while there aren't notification nodes
		await get_tree().create_timer(0.1).timeout
		if get_node("/root/Game/Notification_Container").get_child_count() == 0:
			continue
	
	# instantiates a notification node and adds it to the notifications container
	var notifTemp = notifNode.instantiate()
	notifTemp.get_node("Label").set_text(text)
	get_node("/root/Game/Notification_Container").add_child(notifTemp)
	
	# typewriter effect
	var tween := notifTemp.create_tween()
	tween.tween_property(notifTemp.get_node("Label"), "visible_ratio", 1, 1)
	
	await get_tree().create_timer(duration).timeout
	notifTemp.queue_free()


func _process(_delta):
	if collected == 5:
		all_collected.emit()
	
	check_player_stamina()

func discord_rich():
	discord_sdk.app_id = 1121145118678843494 # Application ID
	print("Discord working: " + str(discord_sdk.get_is_discord_working())) # A boolean if everything worked
	discord_sdk.details = "by hazoky"
	discord_sdk.large_image = "vibes" # Image key from "Art Assets"
	discord_sdk.large_image_text = "Playtest Build!"
	discord_sdk.refresh() # Always refresh after changing the values!

func check_player_stamina():
	if stamina == 0:
		stamina_reached_zero.emit()

func _thread_function_():
	print("inside singleton thread")
	discord_rich()
	ResourceLoader.load_threaded_request(MAP_1)
	ResourceLoader.load_threaded_request(MAP_2)
	

func _exit_tree():
	thread.wait_to_finish()
