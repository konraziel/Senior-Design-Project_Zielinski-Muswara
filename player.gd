extends KinematicBody

# Declare member variables here. Examples:
var speed = 7.0
var gravity = 50
var velocity = Vector3.ZERO
var snap_vector = Vector3.DOWN

export var jump_strength = 20


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
	input_vector= input_vector.rotated(Vector3.UP, rotation.y).normalized()
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
