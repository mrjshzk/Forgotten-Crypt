@tool
extends Node3D
class_name Collectible3D

@onready var pickup_sound := $AudioStreamPlayer3D
@onready var anim_player := $AnimationPlayer
var sound := preload("res://assets/audio/332629__treasuresounds__item-pickup.ogg")

func _process(_delta):
	if not anim_player.is_playing():
		anim_player.play("rotate")

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		pickup_sound.play(0)
		print("im getting collected!")
		SoundManager.play_sound(sound)
		Singleton.collected += 1
		Singleton.notif("vai ta foder " + OS.get_environment("USERNAME"))
		self.queue_free()
		
		

