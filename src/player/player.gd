extends CharacterBody3D

var speed
var can_run := true
const WALK_SPEED = 4.0
const SPRINT_SPEED = 6.5
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
var last_num := 1
var num_range := [1,2,3]

@onready var head := $Head
@onready var camera := $Head/Camera
@onready var raycast := $Head/Camera/RayCast3D
@onready var timer = $Timer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY * Singleton.mouse_sens)
		camera.rotate_x(-event.relative.y * SENSITIVITY * Singleton.mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _process(_delta):
	await Singleton.stamina_reached_zero
	can_run = false
	timer.start(Singleton.stamina_cooldown)
	await timer.timeout
	can_run = true

func _physics_process(delta):
	check_cursor()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

#	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
	# Handle Sprint.
	if Input.is_action_pressed("sprint") and can_run:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			if speed == SPRINT_SPEED:
				$AnimationPlayer.play("run")
				Singleton.stamina = clamp(Singleton.stamina - 2, 0, Singleton.max_stamina)
			else:
				$AnimationPlayer.play("walk")
				Singleton.stamina = clamp(Singleton.stamina + 1, 0, Singleton.max_stamina)
		else:
			Singleton.stamina = clamp(Singleton.stamina + 1, 0, Singleton.max_stamina)
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func check_cursor():
	if raycast.get_collider() != null:
		var collider = raycast.get_collider()
		if collider.is_in_group("interact"):
			Singleton.is_interacting = true
	else:
		Singleton.is_interacting = false

func interact():
	var collider = raycast.get_collider()
	if collider != null and collider.is_in_group("interact"):
		print("calling door")
		collider.get_parent().interact()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func walk():
	var sound_path := "res://assets/audio/footsteps/" + str(num_range.pick_random()) + ".wav"
	var footstep_sound = load(sound_path)
	print(sound_path)
	SoundManager.play_sound(footstep_sound, "footstep")
	
