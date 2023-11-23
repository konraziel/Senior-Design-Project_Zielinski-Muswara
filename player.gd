extends KinematicBody

# Declare member variables here. Examples:
var speed = 7.0
var gravity = 50
var velocity = Vector3.ZERO
var snap_vector = Vector3.DOWN
var mouse_sensitivity = 0.002  # radians/pixel

export var jump_strength = 20

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$PlayerHead.rotate_y(-event.relative.x * mouse_sensitivity)
		$PlayerHead/Camera.rotate_x(-event.relative.y * mouse_sensitivity)
		$PlayerHead/Camera.rotation.x = clamp($PlayerHead/Camera.rotation.x, -1.2, 1.2)

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
	
	var camera_transform = $PlayerHead/Camera.get_global_transform()
	var camera_basis = camera_transform.basis
	input_vector = camera_basis.xform(input_vector).normalized()
	
	velocity.x= input_vector.x *speed
	velocity.z= input_vector.z *speed
	velocity.y-= gravity * delta
	
	var just_landed = is_on_floor() and snap_vector == Vector3.ZERO
	var is_jumping = is_on_floor() and Input.is_action_pressed("ui_select")
	
	if is_jumping:
		velocity.y= jump_strength
		snap_vector= Vector3.ZERO
	elif just_landed:
		snap_vector = Vector3.DOWN
	
	velocity= move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)
