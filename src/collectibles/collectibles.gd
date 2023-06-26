@tool
extends Node3D
class_name Collectible3D

@onready var animation_player = $AnimationPlayer

var sound := preload("res://assets/audio/332629__treasuresounds__item-pickup.ogg")

func _ready():
	animation_player.play("idle")

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D and body.is_in_group("Player"):
		Singleton.collected += 1
		Singleton.notif(str(Singleton.collected) + " of 5 collected.")
		SoundManager.play_music_at_volume(sound, 10)
		self.queue_free()
		
		

