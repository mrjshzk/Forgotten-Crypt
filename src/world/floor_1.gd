extends Node3D

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		$Player/AudioStreamPlayer3D.set_bus("footstep")
		var tween = get_tree().create_tween()
		$Player/AudioStreamPlayer3D2.play()
		tween.tween_property($Player/AudioStreamPlayer3D2, "volume_db", 0, 3)
		$Props/Areas/Area3D2.set_monitoring(true)


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
