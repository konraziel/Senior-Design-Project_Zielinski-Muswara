extends Node

const PORT = 6007
var address = "127.0.0.1"
var num_players = 20
var num_channels = 10
var enet_connection: ENetConnection 

# Called when the node enters the scene tree for the first time.
func _ready():
	enet_connection = ENetConnection.new() # Initialize enet_connection here

func _on_host_pressed():
	print("host")
	var error = enet_connection.create_host_bound(address, PORT, num_players, num_channels) # Corrected arguments for create_host
	
	if error:
		printerr("Failed to create host:", error)
	else:
		print("Host created successfully")

func _on_client_pressed():
	print("client")
	enet_connection.connect_to_host(address, PORT, num_channels) # Corrected arguments for connect_to_host
	if enet_connection.is_active():
		print("Connected to host")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('host'):
		_on_host_pressed()
	if Input.is_action_pressed('client'): # Changed 'guest' to 'client'
		_on_client_pressed()
