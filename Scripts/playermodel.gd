extends CharacterBody3D

var input_vector:Vector3
var speed = 4.0
var gravity = 9.8
var snap_vector = Vector3.DOWN
var mouse_sensitivity = 0.002  # radians/pixel
const LERP_VAL = .01
var anim_movement = Vector3.ZERO

var jump_strength = 4.5

@onready var interaction=$Armature/PlayerHead/Camera3D/interaction
@onready var hand = $Armature/PlayerHead/Camera3D/hand
@onready var anim_tree = $AnimationTree


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
	Global.player=self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Armature.rotate_y(-event.relative.x * mouse_sensitivity)
		$Armature/PlayerHead/Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Armature.rotation.y = wrapf($Armature.rotation.y, deg_to_rad(0), deg_to_rad(360))
		$Armature/PlayerHead/Camera3D.rotation.x = clamp($Armature/PlayerHead/Camera3D.rotation.x, -1.2, 1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if Input.is_action_pressed("alt"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Input handling
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	input_vector = Vector3(input.x, 0, input.y)
	
	if Input.is_action_just_pressed("f"):
		if picked_object== null:
			pick_object()
		elif picked_object != null:
			unpick_object()
	
	var armature_direction = $Armature.transform.basis
	var direction = armature_direction * (input_vector).normalized()
	
	#Global.debug.add_property("x vector", input_vector.x, 1)
	#Global.debug.add_property("z vector", input_vector.z, 2)
	
	velocity.x= lerp(velocity.x, direction.x * speed, LERP_VAL)
	velocity.z= lerp(velocity.z, direction.z * speed, LERP_VAL)
	velocity.y-= gravity * delta
	
	Global.debug.add_property("x velocity", velocity.x, 2)
	Global.debug.add_property("y velocity", velocity.y, 3)
	Global.debug.add_property("z velocity", velocity.z, 4)
	
	var is_jumping = is_on_floor() and Input.is_action_pressed("jump")
	
	if is_jumping:
		velocity.y= jump_strength
	
	#var basis_inverse = armature_direction.inverse()
	#normal_init_input = basis_inverse * direction
	anim_movement.x = lerp(anim_movement.x, input_vector.x, LERP_VAL)
	anim_movement.z = lerp(anim_movement.z, input_vector.z, LERP_VAL)
	
	Global.debug.add_property("animation vector", anim_movement, 4)
	
	var anim_movement_set = Vector2(anim_movement.x, -anim_movement.z)
	anim_tree.set("parameters/BlendSpace2D/blend_position", anim_movement_set)
	
	# TODOConverter3To4 looks that snap in Godot 4 is float, not vector like in Godot 3 - previous value `snap_vector`
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * speed * 0.05)
	
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*4)
