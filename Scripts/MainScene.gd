extends Node3D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://playermodel.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()
var peers: Array
var packets_data: Array

# Debugging variables
var number_of_peers: int
var peer_ID:int

# Called when the node enters the scene tree for the first time.
func _ready():
	var number_of_peers = 0
	set_physics_process(!is_physics_processing())
	set_process(!is_processing())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if number_of_peers != peers.size():
		number_of_peers = peers.size()
		print("mainscene.gd: ", str(number_of_peers) + " peer(s) currently connected")
	
	#for peer in peers:
		#packets_data.append(peer.get_)

func _physics_process(delta):
	pass

func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	set_physics_process(multiplayer.is_server())
	set_process(multiplayer.is_server())
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func _on_players_child_entered_tree(node):
	#print("test")
	if enet_peer.host.EVENT_CONNECT:
		peers = enet_peer.host.get_peers()
	else:
		print_debug("mainscene.gd: EnetConnection Event is wrong!!")

func add_player(peer_id):
	print("mainscene.gd: connecting: " + str(peer_id))
	
	var player = Player.instantiate()
	player.name = str(peer_id)
	#peer_ID=get_tree().get_unique_id()
	$Players.add_child(player)
	
func delete_player(peer_id):
	print("mainscene.gd: disconnecting: " + str(peer_id))
	
	if not $Players.has_node(str(peer_id)):
		return
	$Players.get_node(str(peer_id)).queue_free()

#func _exit_tree():
	#if not multiplayer.is_server():
		#return
	#multiplayer.peer_connected.disconnect(add_player)
	#multiplayer.peer_disconnected.disconnect(delete_player)
