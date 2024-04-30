extends Node3D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var players = $Players

const Player = preload("res://playermodel.tscn")
const PORT = 9999
var enet_peer: ENetMultiplayerPeer
var peers: Array

# Player data 
var server_data: Dictionary
var player_data: Dictionary

# Debugging variables
var number_of_peers: int
#var peer_ID:int
#var test: Array
var multiplayer_peer_check: MultiplayerPeer

# Called when the node enters the scene tree for the first time.
func _ready():
	var number_of_peers = 0
	
	set_physics_process(!is_physics_processing())
	set_process(!is_processing())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if number_of_peers != peers.size():
		#number_of_peers = peers.size()
		#print("mainscene.gd: ", str(number_of_peers) + " peer(s) currently connected")
	pass

func _physics_process(delta):
	pass

func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	multiplayer_peer_check = multiplayer.get_multiplayer_peer()
	print("mainscene.gd - current multiplayer_peer id: ", multiplayer_peer_check.get_unique_id())
	
	set_physics_process(multiplayer.is_server())
	set_process(multiplayer.is_server())
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer_peer_check = multiplayer.get_multiplayer_peer()
	print("mainscene.gd - current multiplayer_peer id: ", multiplayer_peer_check.get_unique_id())

func _on_players_child_entered_tree(node):
	if not multiplayer.is_server(): return
	#print(get_multiplayer_authority())
	if enet_peer.host.EVENT_CONNECT:
		remote_update_peers.rpc()
		#print("mainscene.gd - Peers: ", peers)
		for _i in players.get_children(): print(multiplayer.get_unique_id(), " ", _i)
	else:
		print_debug("mainscene.gd: EnetConnection Event is wrong!!")

@rpc("call_local") # When we detect a player joins, we want to update each local players peer list
func remote_update_peers():
	peers = multiplayer.get_peers()
	print("mainscene.gd: ", multiplayer.get_unique_id(), " - Peers: ", peers)

func add_player(peer_id):
	#print("mainscene.gd: connecting: " + str(peer_id))
	
	var player = Player.instantiate()
	player.name = str(peer_id)
	$Players.add_child(player)

func delete_player(peer_id):
	#print("mainscene.gd: disconnecting: " + str(peer_id))
	
	if not $Players.has_node(str(peer_id)):
		return
	$Players.get_node(str(peer_id)).queue_free()
