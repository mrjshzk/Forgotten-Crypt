@tool
extends MeshInstance3D

@onready var audio_stream = $AudioStreamPlayer3D
@export var flicker := false

func _process(_delta):
	if flicker and $Timer.is_stopped():
		$Timer.start(randf_range(0.5,1))


func _on_timer_timeout():
	self.set_visible(!self.visible)
