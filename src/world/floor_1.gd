extends Node3D

@onready var player = $Player
var thread : Thread


func _ready():
	Singleton.next_map = Singleton.MAP_2


func _physics_process(_delta):
	Singleton.player_pos = player.get_global_position()
	#get_tree().call_group("Enemies", "update_target_location", player.get_global_position())

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		$Player/Head/Camera/SpotLight3D.show()
		$Player/AudioStreamPlayer3D.set_bus("footstep")
		var tween = get_tree().create_tween()
		$Player/AudioStreamPlayer3D2.play()
		tween.tween_property($Player/AudioStreamPlayer3D2, "volume_db", 0, 5)
		$Props/Areas/Area3D2.set_deferred("monitoring", true)

func _on_area_3d_2_body_entered(body):
	if body is CharacterBody3D:
		$Player/Head/Camera/SpotLight3D.hide()
		$Player/AudioStreamPlayer3D.set_bus("master")
		var tween = get_tree().create_tween()
		tween.tween_property($Player/AudioStreamPlayer3D2, "volume_db", -80, 3)


func _on_area_3d_3_body_entered(body):
	if body is CharacterBody3D:
		$Props/Areas/Area3D3/entity_3_func_group.show()
		$Props/Areas/Area3D3/entity_3_func_group.collision_layer = 1

func _on_audio_stream_player_3d_2_finished():
	$Player/AudioStreamPlayer3D2.play()


func _on_area_3d_4_body_entered(body):
	if body.is_in_group("Player"):
		var game = Singleton.GAME
		SceneManager.change_scene(game)


func _on_collectibles_2_tree_exiting():
	$Props/Areas/Area3D3/entity_3_func_group.hide()
	$Props/Areas/Area3D3/entity_3_func_group.set_collision_layer(2)



func _on_audio_stream_player_3d_2_tree_exiting():
	var t = get_tree().create_tween()
	t.tween_property($Player/AudioStreamPlayer3D2, "volume_db", -80, 1.5)


func _on_area_3d_5_body_entered(body):
	if body.is_in_group("Player"):
		var t = get_tree().create_timer(1.5)
		$Props/Areas/Area3D5/AudioStreamPlayer3D.play()
