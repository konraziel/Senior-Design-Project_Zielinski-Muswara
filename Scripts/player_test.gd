extends CharacterBody3D

@onready var HUD = $CanvasLayer/HUD
@onready var healthbar = $CanvasLayer/HUD/HealthBar
var Health=5

func Hit_Success(Damage):
	Health-= Damage
	healthbar.value=Health
	#print("hit successful")
	if Health<= 0:
		queue_free()

var input_vector:Vector3
var speed = 4.0
var gravity = 9.8
#var mouse_sensitivity = 0.002  # radians/pixel
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
		$PlayerHead/Camera3D/WeaponsManager.set_multiplayer_authority(id)


# Player synchronized input.
@onready var input = $PlayerInput

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		camera.current = true
	
	# Only process on server.
	set_physics_process(multiplayer.is_server())

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if input.jumping and is_on_floor():
		velocity.y = jump_strength

	# Reset jump state.
	input.jumping = false
	
	# Input handling	
	var direction = (input.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	
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
