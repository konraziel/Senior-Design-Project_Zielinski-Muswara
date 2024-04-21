# Previous Multiplayer script, will revisit later
extends Node
# Define a signal with a parameter for the player's ID
signal player_joined(peer_id)

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://playermodel.tscn")
var enet_peer = ENetMultiplayerPeer.new()
const PORT = 6007
var address = "127.0.0.1"
# Previous Code for Network test
#var num_players = 20
#var num_channels = 10
#
#var enet_connection: ENetConnection
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#enet_connection = ENetConnection.new()
#func _on_host_pressed():
	#print("host")
	#var error = enet_connection.create_host_bound(address, PORT, num_players, num_channels)
	#if error:
		#printerr("Failed to create host:", error)
	#else:
		#print("Host created successfully")
#
#func _on_client_pressed():
	#print("client")
	#var error = enet_connection.connect_to_host(address, PORT, 0)
	#if error != null:
		#printerr("Failed to connect to host:", error)
	#else:
		#print("Connection request sent to host")
#
#func _input(event):
	#if Input.is_action_pressed('host'):
		#_on_host_pressed()
	#if Input.is_action_pressed('client'):
		#_on_client_pressed()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	


func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	
	enet_peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	print(player.name)
	add_child(player)
	
	# Emit the signal with the player's ID
	emit_signal("player_joined", peer_id)
