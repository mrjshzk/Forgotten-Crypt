extends CharacterBody3D

var speed
var can_run := true
const WALK_SPEED = 4.5
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
var first_stamina_depletion := true

# footstep paths
var footsteps := [preload("res://assets/audio/footsteps/1.ogg"), 
				preload("res://assets/audio/footsteps/2.ogg"), 
				preload("res://assets/audio/footsteps/3.ogg")]




@onready var head := $Head
@onready var camera := $Head/Camera
@onready var raycast := $Head/Camera/RayCast3D
@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Singleton.connect("stamina_reached_zero", apply_stamina_cooldown)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY * Singleton.mouse_sens)
		camera.rotate_x(-event.relative.y * SENSITIVITY * Singleton.mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


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
			$AnimationPlayer.play("idle")
			Singleton.stamina = clamp(Singleton.stamina + 1, 0, Singleton.max_stamina)
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		#$AnimationPlayer.play("idle")
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

func walk(range_1 = 0, range_2 = 5):
	audio_player.set_volume_db(randf_range(range_1, range_2))
	audio_player.set_stream(footsteps.pick_random())
	audio_player.set_pitch_scale(randf_range(0.85,1.15))
	audio_player.play()
	


func apply_stamina_cooldown():
	if first_stamina_depletion:
		first_stamina_depletion = false
		Singleton.notif("When stamina is depleted, you must wait \n" + str(Singleton.stamina_cooldown) + " second to run again.")
	can_run = false
	timer.start(Singleton.stamina_cooldown)
	await timer.timeout
	can_run = true
