extends Node3D
class_name Door3D

var is_opened : bool = false
var can_move : bool = true
var locked : bool = false
var send_locked_notif : bool = false
var open_door_time := 1.0

@onready var audio_stream_player_3d := $AudioStreamPlayer3D
var door_sound := preload("res://assets/audio/431117__inspectorj__door-front-opening-a.ogg")

func _ready():
	audio_stream_player_3d.set_stream(door_sound)

func interact():
	if not locked:
		if is_opened:
			close_door()
		else:
			open_door()
	elif locked and not send_locked_notif:
		send_locked_notif = true
		Singleton.notif("The door is locked.")

func open_door():
	if not is_opened and can_move and not locked:
		is_opened = true
		var tween = create_tween()
		audio_stream_player_3d.play()
		tween.tween_property(self, "rotation_degrees:y", self.rotation_degrees.y+90, open_door_time).set_ease(Tween.EASE_IN_OUT)
		can_move = false
		
		await get_tree().create_timer(open_door_time).timeout
		can_move = true

	
func close_door():
	if is_opened and can_move and not locked:
		is_opened = false
		var tween = create_tween()
		audio_stream_player_3d.play()
		tween.tween_property(self, "rotation_degrees:y", self.rotation_degrees.y-90, open_door_time).set_ease(Tween.EASE_IN_OUT)
		can_move = false
		
		await get_tree().create_timer(open_door_time).timeout
		can_move = true

