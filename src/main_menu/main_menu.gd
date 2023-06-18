extends Node

@onready var settings = $CanvasLayer/Settings
@onready var main = $CanvasLayer/Main

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_back_pressed():
	settings.hide()
	main.show()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://src/world/game.tscn")


func _on_options_pressed():
	main.hide()
	settings.show()


func _on_quit_pressed():
	get_tree().quit(0)
