# Previous Multiplayer script, will revisit later
extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const PORT = 9999

# Previous Code for Network test
#var num_players = 20
#var num_channels = 10
#
#var enet_connection: ENetConnection
#
# Called when the node enters the scene tree for the first time.
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

# Debugging variables
#var number_of_peers: int
#var peer_ID:int
#var test: Array
var multiplayer_peer_check: MultiplayerPeer

func _on_host_button_pressed():
	
	var enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(PORT, 2)
	if enet_peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	
	multiplayer.multiplayer_peer = enet_peer
	start_game()
	
	multiplayer_peer_check = multiplayer.get_multiplayer_peer()
	print("mainscene.gd - current multiplayer_peer id: ", multiplayer_peer_check.get_unique_id())

func _on_join_button_pressed():
	
	var enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client("localhost", PORT)
	if enet_peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	
	multiplayer.multiplayer_peer = enet_peer
	start_game()
	
	multiplayer_peer_check = multiplayer.get_multiplayer_peer()
	print("mainscene.gd - current multiplayer_peer id: ", multiplayer_peer_check.get_unique_id())

func start_game():
	# Hide the UI and unpause to start the game.
	main_menu.hide()
	Engine.max_fps = 60
	Engine.physics_ticks_per_second = 60
	
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://Level.tscn"))

# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())

#func _input(event):
	#if not multiplayer.is_server():
		#return
	#if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		#change_level.call_deferred(load("res://Level.tscn"))
