extends CharacterBody3D


var speed = 7.0
var gravity = 9.8
#var velocity = Vector3.ZERO
var snap_vector = Vector3.DOWN
var mouse_sensitivity = 0.002  # radians/pixel

var jump_strength = 4.5

@onready var interaction=$PlayerHead/Camera3D/interaction
@onready var hand = $PlayerHead/Camera3D/hand


var picked_object
var pull_strength


func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object=collider
func unpick_object():
	if picked_object != null:
		picked_object=null



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$PlayerHead.rotate_y(-event.relative.x * mouse_sensitivity)
		$PlayerHead/Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$PlayerHead.rotation.y = wrapf($PlayerHead.rotation.y, deg_to_rad(0), deg_to_rad(360))
		$PlayerHead/Camera3D.rotation.x = clamp($PlayerHead/Camera3D.rotation.x, -1.2, 1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input handling
	var input_vector = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_just_pressed("f"):
		if picked_object== null:
			pick_object()
		elif picked_object != null:
			unpick_object()

	Global.debug.add_property("x vector", input_vector.x, 3)
	Global.debug.add_property("y vector", input_vector.y, 4)
	Global.debug.add_property("z vector", input_vector.z, 5)
	if Input.is_action_pressed("alt"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	input_vector = $PlayerHead.transform.basis * (input_vector).normalized()
	
	velocity.x= input_vector.x *speed
	velocity.z= input_vector.z *speed
	velocity.y-= gravity * delta
	
	var just_landed = is_on_floor() and snap_vector == Vector3.ZERO
	var is_jumping = is_on_floor() and Input.is_action_pressed("ui_select")
	
	Global.debug.add_property("just_landed", just_landed, 3)
	
	if is_jumping:
		velocity.y= jump_strength
		snap_vector= Vector3.ZERO
	elif just_landed:
		snap_vector = Vector3.DOWN
	
	set_velocity(velocity)
	# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `snap_vector`
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	velocity= velocity
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * speed * 0.05)
	
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*4)



