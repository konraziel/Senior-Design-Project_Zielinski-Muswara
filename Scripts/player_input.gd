extends MultiplayerSynchronizer

# Set via RPC to simulate is_action_just_pressed.
@export var jumping := false

# Synchronized property.
@export var direction := Vector2()
@export var basis := Basis()

@onready var player = $".."
@onready var camera = $"../PlayerHead/Camera3D"
@onready var interaction = $"../PlayerHead/Camera3D/interaction"
@onready var hand = $"../PlayerHead/Camera3D/hand"

var mouse_capture = true
var mouse_sensitivity = 0.002  # radians/pixel

func _ready():
	# Only process for the local player.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	set_process_unhandled_input(get_multiplayer_authority() == multiplayer.get_unique_id())

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		player.rotation.y = wrapf(player.rotation.y, deg_to_rad(0), deg_to_rad(360))
		camera.rotation.x = clamp(camera.rotation.x, -1.2, 1.2)

@rpc("call_local")
func jump():
	jumping = true

func mouse_capture_true():
	mouse_capture = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func mouse_capture_false():
	mouse_capture = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	if Input.is_action_just_pressed("alt"):
		if mouse_capture == false:
			mouse_capture_true()
		elif mouse_capture != false:
			mouse_capture_false()
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	basis = player.transform.basis
	
	#if direction != Vector2():
		#print(basis)
	
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()
