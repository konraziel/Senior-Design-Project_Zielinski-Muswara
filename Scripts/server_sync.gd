extends MultiplayerSynchronizer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_replication_interval(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#print(get_replication_interval())
