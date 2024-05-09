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

var rng = RandomNumberGenerator.new()
var elapsed_time = 0
var unreliable_flag := false
 
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

@rpc("call_local")
func jump():
	jumping = true

@rpc("call_local")
func shoot():
	shooting = true

@rpc("call_local")
func reload():
	reloading = true

@rpc("call_local")
func scroll_down():
	wheel_down = true

@rpc("call_local")
func scroll_up():
	wheel_up = true

func mouse_capture_true():
	mouse_capture = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func mouse_capture_false():
	mouse_capture = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	# Imitating fluctuating latency in network
	imitate_network_lag(false)
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

func imitate_network_lag(flag: bool):
	if not flag: return
	var random_num = rng.randf()
	
	if random_num < .005 and unreliable_flag == false:
		#print(random_num)
		unreliable_flag = true

	if unreliable_flag == true:
		set_replication_interval(random_num*50)
		#print(get_replication_interval())
		unreliable_flag = false
