extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child($playermodel) # use this to disable the old avatar
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
