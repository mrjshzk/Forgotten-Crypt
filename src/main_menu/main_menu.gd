extends Node


@onready var main = $CanvasLayer/SubViewportContainer/Main
@onready var play = $CanvasLayer/SubViewportContainer/Main/VBoxContainer/Play

@onready var quit = $CanvasLayer/SubViewportContainer/Main/VBoxContainer/Quit




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	quit.connect("pressed", _on_quit_pressed)

	play.connect("pressed", _on_play_pressed)

func _on_play_pressed():
	if RenderingServer.get_rendering_device():
		SceneManager.change_scene(Singleton.GAME)
	else:
		SceneManager.change_scene(load("res://src/no_vulkan/no_vulkan.tscn"))

func _on_quit_pressed():
	get_tree().quit(0)
