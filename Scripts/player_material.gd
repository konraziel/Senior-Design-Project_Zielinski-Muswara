extends MeshInstance3D

var rng = RandomNumberGenerator.new()
var player_mat = preload("res://models/Material/player_mat.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	var r = rng.randf()
	var b = rng.randf()
	var g = rng.randf()
	player_mat.albedo_color = Color(r, b, g, 1)
	set_surface_override_material(0, player_mat)
