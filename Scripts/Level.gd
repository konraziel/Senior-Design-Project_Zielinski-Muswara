extends Node3D

func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server(): return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func _exit_tree():
	if not multiplayer.is_server(): return
	
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(delete_player)

func add_player(peer_id: int):
	var character = preload("res://playermodel.tscn").instantiate()
	# Set player id.
	character.player = peer_id
	character.name = str(peer_id)
	$Players.add_child(character, true)

func delete_player(peer_id):
	#print("Level.gd: disconnecting: " + str(peer_id))
	
	if not $Players.has_node(str(peer_id)):
		return
	$Players.get_node(str(peer_id)).queue_free()
