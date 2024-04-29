extends CharacterBody3D

signal sending_player_input(peer_id, peer_inputs)

###########PEERS-INPUTS##############
var peer_inputs = {}
##########################

var input_vector:Vector3
var speed = 4.0
var gravity = 9.8
var snap_vector = Vector3.DOWN
var mouse_sensitivity = 0.002  # radians/pixel
const LERP_VAL = .1
var anim_movement = Vector3.ZERO
var jump_strength = 4.5

var input_array=[0,0,false]
var position_array = [0,0,0]
var body_basis_array = [[1,0,0],[0,0,1]]
var camera_basis_array = [[0,1,0],[0,0,1]]

@onready var camera = $PlayerHead/Camera3D
@onready var interaction = $PlayerHead/Camera3D/interaction
@onready var hand = $PlayerHead/Camera3D/hand

var picked_object
var mouse_capture = true
var pull_strength

#func _enter_tree():
	#set_multiplayer_authority(str(name).to_int())

func _ready():
	set_multiplayer_authority(str(name).to_int())
	
	print("playermodel.gd: ", multiplayer.multiplayer_peer.get_unique_id())
	
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
	#print(str(multiplayer.get_unique_id()), " received ", peer_inputs)
	
	if not is_multiplayer_authority(): return
	
	if not multiplayer.is_server():
		
		var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		input_array = [input.x, input.y, Input.is_action_just_pressed("jump")]
		
		position_array = [global_position.x, global_position.y, global_position.z]
		body_basis_array = [transform.basis.x, transform.basis.z]
		camera_basis_array = [camera.transform.basis.y, camera.transform.basis.z]
		
		if input != Vector2(0,0):
			rpc_id(1, "send_player_input", input_array, position_array, body_basis_array, camera_basis_array)
		
		if Input.is_action_just_pressed("alt"):
			if mouse_capture == false:
				mouse_capture_true()
			elif mouse_capture != false:
				mouse_capture_false()
		
	else:
		
		#print(peer_inputs)
		
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
		var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		
		#var pos = get_global_position()
		#position_array = [pos.x, pos.y, pos.z]
		#if input != Vector2(0,0):
			#print(position_array)
			#print(camera.transform.basis)
			
		
		#Global.debug.add_property("x vector", input_vector.x, 1)
		#Global.debug.add_property("z vector", input_vector.z, 2)
		
		velocity.x= lerp(velocity.x, direction.x * speed, LERP_VAL)
		velocity.z= lerp(velocity.z, direction.z * speed, LERP_VAL)
		
		velocity.x= lerp(velocity.x, direction.x * speed, LERP_VAL)
		velocity.z= lerp(velocity.z, direction.z * speed, LERP_VAL)
		
		#Global.debug.add_property("x velocity", velocity.x, 2)
		#Global.debug.add_property("y velocity", velocity.y, 3)
		#Global.debug.add_property("z velocity", velocity.z, 4)
		
		#var basis_inverse = armature_direction.inverse()
		#normal_init_input = basis_inverse * direction
		
		move_and_slide()
		
		#for i in get_slide_collision_count():
			#var c = get_slide_collision(i)
			#if c.get_collider() is RigidBody3D:
				#c.get_collider().apply_central_impulse(-c.get_normal() * speed * 0.05)
		
		if picked_object != null:
			var a = picked_object.global_transform.origin
			var b = hand.global_transform.origin
			picked_object.set_linear_velocity((b-a)*4)

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

#func _on_sending_player_input(peer_id, peer_inputs):
	#pass # Replace with function body.

@rpc("any_peer", "call_local")
func send_player_input(player_input, player_position, body_basis, camera_basis):
	var sender_id = multiplayer.get_remote_sender_id()
	peer_inputs[sender_id]=[player_input, player_position, body_basis, camera_basis]
	#print(str(multiplayer.get_unique_id()), " received ", str(player_input)) 
