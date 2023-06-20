extends Node

var mouse_sens := 1.0
var collected := 0
var is_interacting := false
var player_pos
var has_flashlight := false
var stamina := max_stamina
var stamina_cooldown := 1.0

const max_stamina := 500
const notifNode = preload("res://src/notification/notification.tscn")

signal stamina_reached_zero()

func notif(text: String, duration: float = 3):
	while get_node("/root/Game/Notifications").get_child_count() != 0:
		await get_tree().create_timer(0.1).timeout
		if get_node("/root/Game/Notifications").get_child_count() == 0:
			continue
	var notifTemp = notifNode.instantiate()
	notifTemp.get_node("Label").set_text(text)
	get_node("/root/Game/Notifications").add_child(notifTemp)
	var tween := notifTemp.create_tween()
	tween.tween_property(notifTemp.get_node("Label"), "visible_ratio", 1, 1)
	print("should send notification")
	await get_tree().create_timer(duration).timeout
	notifTemp.queue_free()
	print("deleted notification")

func _process(_delta):
	if stamina == 0:
		stamina_reached_zero.emit()
