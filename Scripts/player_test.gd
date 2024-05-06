extends CharacterBody3D

signal health_change 
signal shot
var Health=5

func Hit_Success(Damage):
	Health-= Damage
	emit_signal("health_change", Health)
	#print("hit successful")
	if Health<= 0:
		queue_free()



var input_vector:Vector3
var speed = 4.0
var gravity = 9.8
var mouse_sensitivity = 0.002  # radians/pixel
const LERP_VAL = .1
var jump_strength = 4.5

@onready var camera = $PlayerHead/Camera3D
@onready var interaction = $PlayerHead/Camera3D/interaction
@onready var hand = $PlayerHead/Camera3D/hand

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)
		$CanvasLayer.set_multiplayer_authority(id)
		$UI/DebugPanel.set_multiplayer_authority(id)
		#$PlayerHead/Camera3D/WeaponsManager.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $PlayerInput
var prev_mouse_move := Vector2()
var camera_move := Vector2()

func _ready():
	if player == multiplayer.get_unique_id():
		camera.current = true
	
	set_physics_process(multiplayer.is_server())
	set_process(multiplayer.is_server())

#func _unhandled_input(event):
	#if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#rotate_y(-input.mouse_move_relative.x * mouse_sensitivity)
		#camera.rotate_x(-input.mouse_move_relative.y * mouse_sensitivity)
		#rotation.y = wrapf(rotation.y, deg_to_rad(0), deg_to_rad(360))
		#camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)

func _process(_delta):
	# Camera and Body rotation
	if input.mouse_move_relative == prev_mouse_move:
		camera_move = Vector2.ZERO
	else:
		camera_move = input.mouse_move_relative
	
	rotate_y(-camera_move.x * mouse_sensitivity)
	camera.rotate_x(-camera_move.y * mouse_sensitivity)
	rotation.y = wrapf(rotation.y, deg_to_rad(0), deg_to_rad(360))
	camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)
	
	prev_mouse_move = input.mouse_move_relative

func _physics_process(delta):
	# Gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if input.jumping and is_on_floor():
		velocity.y = jump_strength
		print(multiplayer.get_unique_id(), " jumped")
	
	if input.shooting:
		emit_signal("shot")
	# Reset jump state.
	input.jumping = false
	input.shooting = false
	# Input handling	
	var direction = (transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	
	#Global.debug.add_property("x vector", input_vector.x, 1)
	#Global.debug.add_property("z vector", input_vector.z, 2)
	
	velocity.x= lerp(velocity.x, direction.x * speed, LERP_VAL)
	velocity.z= lerp(velocity.z, direction.z * speed, LERP_VAL)
	
	velocity.x= lerp(velocity.x, direction.x * speed, LERP_VAL)
	velocity.z= lerp(velocity.z, direction.z * speed, LERP_VAL)
	
	#Global.debug.add_property("x velocity", velocity.x, 2)
	#Global.debug.add_property("y velocity", velocity.y, 3)
	#Global.debug.add_property("z velocity", velocity.z, 4)
	
	move_and_slide()
	
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody3D:
			#c.get_collider().apply_central_impulse(-c.get_normal() * speed * 0.05)
