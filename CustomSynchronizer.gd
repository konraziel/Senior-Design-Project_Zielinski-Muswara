extends Node
var playernode:CharacterBody3D
var enet_peer:ENetMultiplayerPeer
var world_node:Node3D
var current_peer:ENetPacketPeer
var peers:Array 

var debug: Array

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
	
	#pass # Replace with function body.
	world_node = find_parent_node_by_name("World")
	#if(world_node == null):
		#print("ye")
	#else:
		#print("no")
	enet_peer=world_node.enet_peer
	print(enet_peer)

	var enet_connection_host=enet_peer.host
	peers= enet_connection_host.get_peers()
	
	#print("Get unique id: ", multiplayer.get_unique_id())
	if multiplayer.is_server():
		print("server")
	
	#debug = playernode.send_array
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not is_multiplayer_authority(): return
	if multiplayer.is_server(): return
	#if playernode.send_array == debug: return
	
	
	#var client_input=PackedByteArray(playernode.send_array)
	#current_peer=peers[0]
	#current_peer.send(0, client_input, 1)
	
	#debug = playernode.send_array
	
	#print("world_node: ",world_node.peer_ID)
	#print("ENetMultiplayerPeer: ", enet_peer)
	#print(enet_peer.get_peer(world_node.peerID))
	#if current_peer==null:
		#print("yes")
	#else:
		#print("no1")
	#current_peer.send(0, client_input,1)
	#
	#
