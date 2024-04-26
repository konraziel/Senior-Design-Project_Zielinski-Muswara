extends Node3D
const Player= preload("res://playermodel.tscn")

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
var port = 4452  # You may change this port if needed

var enet_connection = ENetConnection.new()
var enet2 = ENetConnection.new()
var client_peer: ENetPacketPeer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(address_entry.text)
	pass
	
	#print(enet_connection.get_peers())
func _physics_process(delta):
	pass

func receive_packets():
	pass


func _on_host_button_pressed():
	if not is_multiplayer_authority(): return
	main_menu.hide()
		
	var address = address_entry.text

	
	# Debug parameter values
	print("Address:", address)
	print("Port:", port)
		
	print("Attempting to create host on address: ", address, " and port: ", port)
		
	# Create the host bound to the given address and port
	var error = enet_connection.create_host_bound("127.0.0.1", port, 2,  2, 0)
		
	# Check for errors and provide feedback
	if error == OK:
		print("Host created successfully on address: ", address, " and port: ", port)
		add_player(enet_connection)
	else:
		print("Failed to create host. Error code: ", error)



func _on_join_button_pressed():
	main_menu.hide()
	var address = "127.0.0.1"
	
	
	print("Attempting to connect to host at address:", address, " and port:", port)
	if enet2==null:
		return
	add_player(enet2)
	# Attempt to connect to the host
	client_peer = enet2.connect_to_host(address, port, 1, 0)
	#
	## Check the result of the connection attempt
	
	if client_peer == null:
		print("Failed to connect to host.")
	else:
		print("Successfully connected to host.")

	
func add_player(enet_peer):
	print("mainscene.gd: connecting: " ,enet_peer)
	
	var player = Player.instantiate()
	#player.name = str(enet_packet_peer)
	#peer_ID=get_tree().get_unique_id()
	$Players.add_child(player)
