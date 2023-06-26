extends Control

func _ready():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		$VBoxContainer2/Fullscreen.button_pressed = true
	else:
		$VBoxContainer2/Fullscreen.button_pressed = false

func _on_quit_pressed():
	get_tree().quit(0)


func _on_resume_pressed():
	self.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_options_pressed():
	$VBoxContainer.hide()
	$VBoxContainer2.show()


func _on_back_pressed():
	$VBoxContainer2.hide()
	$VBoxContainer.show()


func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
	elif button_pressed == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))

