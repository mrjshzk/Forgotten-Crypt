extends Node

@onready var crosshair := $Crosshair
@onready var progress_bar = $ProgressBar
var tween

func _ready():
	progress_bar.max_value = Singleton.max_stamina

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Singleton.is_interacting:
		crosshair.set_texture(load("res://assets/textures/crosshair001.png"))
	if not Singleton.is_interacting:
		crosshair.set_texture(null)
	progress_bar.value = Singleton.stamina

