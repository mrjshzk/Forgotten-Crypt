extends Node3D

var is_opened : bool = false
var can_move : bool = true
var locked : bool = false
var send_locked_notif : bool = false
var open_door_time := 1.0

@onready var audio_stream_player_3d := $AudioStreamPlayer3D

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
		@warning_ignore("int_as_enum_without_cast")
		tween.tween_property(self, "rotation_degrees:y", self.rotation_degrees.y+90, open_door_time).set_trans(4).set_ease(Tween.EASE_IN_OUT)
		can_move = false
		
		await get_tree().create_timer(open_door_time).timeout
		can_move = true

	
func close_door():
	if is_opened and can_move and not locked:
		is_opened = false
		var tween = create_tween()
		audio_stream_player_3d.play()
		@warning_ignore("int_as_enum_without_cast")
		tween.tween_property(self, "rotation_degrees:y", self.rotation_degrees.y-90, open_door_time).set_trans(4).set_ease(Tween.EASE_IN_OUT)
		can_move = false
		
		await get_tree().create_timer(open_door_time).timeout
		can_move = true

