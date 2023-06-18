@tool
extends Node3D
@onready var animation_player = $AnimationPlayer

var sound := preload("res://assets/audio/332629__treasuresounds__item-pickup.ogg")

signal item_picked()

func _ready():
	animation_player.play("idle")

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		SoundManager.play_sound(sound)
		item_picked.emit()
		self.queue_free()
		


func _on_animation_player_animation_finished(_anim_name):
	animation_player.play("idle")
