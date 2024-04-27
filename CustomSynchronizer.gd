extends Node
var playernode:CharacterBody3D
var enet_peer:ENetMultiplayerPeer
var world_node:Node3D
var current_peer:ENetPacketPeer
var local_peers:Array

var debug: Array
var packet_debug: PackedByteArray

func find_parent_node_by_name(node_name: String) -> Node:
	
	var current_node = self  #node (PlayerModel)
	
	while current_node:
		current_node = current_node.get_parent()
		
		if current_node and current_node.name == node_name:
			return current_node
	
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_multiplayer_authority(): return
	
	#playernode to get position
	playernode=self.get_parent()
	world_node = find_parent_node_by_name("World")
	
	#enet_peer = world_node.enet_peer
	#print("CustomSynchronizer - ENet Peer: ", enet_peer, " ID: ", multiplayer.get_unique_id())
	#local_peers = world_node.peers
	
	#print("Get unique id: ", multiplayer.get_unique_id())
	#if multiplayer.is_server():
		#print("CustomSynchronizer: server")
	
	#debug = playernode.send_array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not is_multiplayer_authority(): return
	if multiplayer.is_server(): return
	
	#var testing_get_packet_peer = enet_peer.get_packet_peer()
	#print("CustomSynchronizer - Get ENet Peer ID from Packet: ", testing_get_packet_peer)
	
	#debug = playernode.send_array
	
	#print("world_node: ",world_node.peer_ID)
	#print("ENetMultiplayerPeer: ", enet_peer)
	#print(enet_peer.get_peer(world_node.peerID))
	#if current_peer==null:
		#print("yes")
	#else:
		#print("no1")
	#current_peer.send(0, client_input,1)
