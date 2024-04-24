extends Node

func find_parent_node_by_name(node_name: String) -> Node:
	var current_node = self  #node (PlayerModel)
	
	while current_node:
		current_node = current_node.get_parent()
		
		if current_node and current_node.name == node_name:
			return current_node
	

	return null


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	var world_node = find_parent_node_by_name("World")
	if(world_node == null):
		print("ye")
	else:
		print("no")
	var enet_peer=world_node.enet_peer

	var enet_connection_host=enet_peer.host
	var peers= enet_connection_host.get_peers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(peers)
	pass
