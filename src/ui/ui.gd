extends Node

@onready var crosshair := $Crosshair
@onready var progress_bar = $ProgressBar
@onready var texture := preload("res://assets/textures/crosshair001.png")
var tween

func _ready():
	progress_bar.max_value = Singleton.max_stamina

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Singleton.is_interacting:
		crosshair.call_deferred("set_texture", texture)
	if not Singleton.is_interacting:
		crosshair.call_deferred("set_texture", null)
	progress_bar.call_deferred("set_value", Singleton.stamina)
	

