extends MultiplayerSynchronizer

var rng = RandomNumberGenerator.new()
var elapsed_time = 0
var unreliable_flag := false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_replication_interval(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	imitate_network_lag(false)

func imitate_network_lag(flag: bool):
	if not flag: return
	var random_num = rng.randf()
	
	if random_num < .005 and unreliable_flag == false:
		#print(random_num)
		unreliable_flag = true

	if unreliable_flag == true:
		set_replication_interval(random_num*50)
		#print(get_replication_interval())
		unreliable_flag = false
