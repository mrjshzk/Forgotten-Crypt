extends Node3D

@onready var player = $Player

func _ready():
	Singleton.connect("all_collected", _all_collected)
	$Player/AudioStreamPlayer3D.set_bus("footstep")
	$Door/AudioStreamPlayer3D.set_bus("footstep")
	$Door2/AudioStreamPlayer3D.set_bus("footstep")
	$Door3/AudioStreamPlayer3D.set_bus("footstep")

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		$QodotMap/entity_5_func_group.queue_free()
		$QodotMap/entity_6_func_group.set_position(Vector3(0,5.625,-4.375))
		$Door.close_door()
		$Areas/Area3D.queue_free()


func _all_collected():
	var t = create_tween()
	t.tween_property($Player/AudioStreamPlayer3D2, "volume_db", -80, 1)
	$FogVolumes/FogVolume4.hide()
	$QodotMap/entity_8_func_group.hide()
	$QodotMap/entity_8_func_group.set_collision_layer_value(1, false)
	


func _on_collectible_4_tree_exiting():
	$Lights/OmniLight3D8.queue_free()
	$Player/Head/Camera/SpotLight3D.show()
	$DirectionalLight3D.set_rotation_degrees(Vector3(-15.9,-153.8,-27))


func _on_area_3d_body_2_entered(body):
	if body.is_in_group("Player"):
		Singleton.notif("The game is quitting in 3 seconds", 3)
		var timer = get_tree().create_timer(3)
		await timer.timeout
		get_tree().quit(0)


func _on_audio_stream_player_3d_2_finished():
	$Player/AudioStreamPlayer3D2.play()


func _on_area_3d_4_body_entered(body):
	if body.is_in_group("Player"):
		var t = get_tree().create_timer(1)
		await t.timeout
		$Areas/Area3D4/AudioStreamPlayer3D.play()
		await $Areas/Area3D4/AudioStreamPlayer3D.finished
		$Areas/Area3D4.queue_free()


func _on_area_3d_3_body_entered(body):
	if body.is_in_group("Player"):
		var t = get_tree().create_timer(2.5)
		await t.timeout
		$Areas/Area3D3/AudioStreamPlayer3D.play()
		await $Areas/Area3D3/AudioStreamPlayer3D.finished
		$Areas/Area3D3.queue_free()


func _on_area_3d_2_body_entered(body):
	if body.is_in_group("Player"):
		var t = get_tree().create_timer(2)
		await t.timeout
		$Areas/Area3D2/AudioStreamPlayer3D.play()
		await $Areas/Area3D2/AudioStreamPlayer3D.finished
		$Areas/Area3D2.queue_free()
