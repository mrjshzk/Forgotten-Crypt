extends Control

@onready var quit = $Quit
@onready var play = $Play


func _ready():
	quit.connect("pressed", _quit_pressed_)
	play.connect("pressed", _you_are_a_savage_)

	
func _you_are_a_savage_():
	print("You are a savage")
	get_tree().change_scene_to_file("res://src/world/game.tscn")

func _quit_pressed_():
	get_tree().quit(0)
	
