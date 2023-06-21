extends Node3D

@onready var player = $Player

func _physics_process(delta):
	get_tree().call_group("Enemies", "update_target_location", player.global_transform.origin)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		$NavigationRegion3D.bake_navigation_mesh()
		Singleton.notif("NavMesh rebaked.", 2)

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		$Player/AudioStreamPlayer3D.set_bus("footstep")
		var tween = get_tree().create_tween()
		$Player/AudioStreamPlayer3D2.play()
		tween.tween_property($Player/AudioStreamPlayer3D2, "volume_db", 0, 3)
		$Props/Areas/Area3D2.set_deferred("monitoring", true)


func _on_area_3d_2_body_entered(body):
	if body is CharacterBody3D:
		$Player/AudioStreamPlayer3D.set_bus("master")
		var tween = get_tree().create_tween()
		tween.tween_property($Player/AudioStreamPlayer3D2, "volume_db", -80, 3)


func _on_area_3d_3_body_entered(body):
	if body is CharacterBody3D:
		$Props/Areas/Area3D3/entity_3_func_group.show()
		$Props/Areas/Area3D3/entity_3_func_group.collision_layer = 1


func _on_area_3d_4_body_entered(body):
	if body is CharacterBody3D:
		get_tree().quit(0)


func _on_audio_stream_player_3d_2_finished():
	$Player/AudioStreamPlayer3D2.play()
