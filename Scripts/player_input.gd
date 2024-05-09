extends MultiplayerSynchronizer

# Set via RPC to simulate is_action_just_pressed.
@export var jumping := false
@export var shooting := false
@export var reloading := false
@export var wheel_down := false
@export var wheel_up := false

# Synchronized property.
@export var direction := Vector2()
@export var mouse_move_relative := Vector2()

@onready var player = $".."
#@onready var camera = $"../PlayerHead/Camera3D"
 
var mouse_capture = true
#var mouse_sensitivity = 0.002  # radians/pixel

func _ready():
	# Only process for the local player.
	
	if player.player == multiplayer.get_unique_id():
		set_replication_interval(0)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	set_process_unhandled_input(get_multiplayer_authority() == multiplayer.get_unique_id())

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_move_relative = event.relative

@rpc("call_local", "unreliable_ordered")
func jump():
	jumping = true

@rpc("call_local", "unreliable_ordered")
func shoot():
	shooting = true

@rpc("call_local", "unreliable_ordered")
func reload():
	reloading = true

@rpc("call_local", "unreliable_ordered")
func scroll_down():
	wheel_down = true

@rpc("call_local", "unreliable_ordered")
func scroll_up():
	wheel_up = true

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
	
	if Input.is_action_just_pressed("Shoot"):
		shoot.rpc()
	if Input.is_action_just_pressed("Reload"):
		reload.rpc()
	if Input.is_action_just_pressed("Weapon_DOWN"):
		scroll_down.rpc()
	if Input.is_action_just_pressed("Weapon_UP"):
		scroll_up.rpc()
	
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()
