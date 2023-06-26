extends Node

@onready var pause_menu := $"Pause Menu"
@onready var sub_viewport = $Viewport/LCDPostProcess/SubViewport

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_menu.show()
		get_tree().paused = true
		
func _ready():
	while ResourceLoader.load_threaded_get_status(Singleton.next_map) != 3:
		continue
	sub_viewport.add_child(ResourceLoader.load_threaded_get(Singleton.next_map).instantiate())

