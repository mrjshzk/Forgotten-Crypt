extends Control


func _on_quit_pressed():
	get_tree().quit(0)


func _on_resume_pressed():
	self.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_option_button_item_selected(index):
	if get_parent().find_child("SubViewport"):
		var node = get_parent().find_child("SubViewport")
		if index == 0:
			node.set_debug_draw(0)
		elif index == 1:
			node.set_debug_draw(4)
		elif index == 2:
			node.set_debug_draw(3)
