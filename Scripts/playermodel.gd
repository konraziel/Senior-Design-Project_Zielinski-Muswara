extends CharacterBody3D

var input_vector:Vector3
var speed = 4.0
var gravity = 9.8
var snap_vector = Vector3.DOWN
var mouse_sensitivity = 0.002  # radians/pixel
const LERP_VAL = .1
var anim_movement = Vector3.ZERO
var jump_strength = 4.5

var send_array:Array

@onready var camera = $PlayerHead/Camera3D
@onready var interaction = $PlayerHead/Camera3D/interaction
@onready var hand = $PlayerHead/Camera3D/hand
#@onready var anim_tree = $AnimationTree

var picked_object
var mouse_capture = true
var pull_strength

func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object=collider
func unpick_object():
	if picked_object != null:
		picked_object=null

func mouse_capture_true():
	mouse_capture = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func mouse_capture_false():
	mouse_capture = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	# -- This is breaking the instances if its put in, similar line of code in _unhandled_input and _process
	# -- The point of this is to make sure that the server and client can only control their corresponding player
	if not is_multiplayer_authority(): return
	
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		$".".rotation.y = wrapf($".".rotation.y, deg_to_rad(0), deg_to_rad(360))
		camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not multiplayer.is_server():
		#inputs to send
		var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		send_array = [input.x, input.y, Input.is_action_just_pressed("jump")]
		

	else:
	
		if Input.is_action_just_pressed("alt"):
			if mouse_capture == false:
				mouse_capture_true()
			elif mouse_capture != false:
				mouse_capture_false()
		
		if Input.is_action_just_pressed("f"):
			if picked_object== null:
				pick_object()
			elif picked_object != null:
				unpick_object()
		
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_strength
		
		# Input handling
		var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")	
		#var armature_direction = $Armature.transform.basis
		var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		
		#Global.debug.add_property("x vector", input_vector.x, 1)
		#Global.debug.add_property("z vector", input_vector.z, 2)
		
		velocity.x= lerp(velocity.x, direction.x * speed, LERP_VAL)
		velocity.z= lerp(velocity.z, direction.z * speed, LERP_VAL)
		
		#Global.debug.add_property("x velocity", velocity.x, 2)
		#Global.debug.add_property("y velocity", velocity.y, 3)
		#Global.debug.add_property("z velocity", velocity.z, 4)
		
		#var basis_inverse = armature_direction.inverse()
		#normal_init_input = basis_inverse * direction
		
		# Animation stuff, maybe use later
		#var anim_vector = transform.basis.inverse() * velocity / speed
		#anim_movement.x = anim_vector.x
		#anim_movement.z = anim_vector.z
		#var anim_movement_set = Vector2(anim_movement.x, -anim_movement.z)
		#anim_tree.set("parameters/BlendSpace2D/blend_position", anim_movement_set)
		
		#Global.debug.add_property("animation vector", anim_movement, 4)
		
		move_and_slide()
		
		#for i in get_slide_collision_count():
			#var c = get_slide_collision(i)
			#if c.get_collider() is RigidBody3D:
				#c.get_collider().apply_central_impulse(-c.get_normal() * speed * 0.05)
		
		if picked_object != null:
			var a = picked_object.global_transform.origin
			var b = hand.global_transform.origin
			picked_object.set_linear_velocity((b-a)*4)
