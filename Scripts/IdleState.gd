extends State


#if inputvector is zero
func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	#pass
	if Global.player.input_vector.x != 0: 
		Transition.emit(self, "walkingstate")
	if Global.player.input_vector.z != 0: 
		Transition.emit(self, "walkingstate")


func enter():
	pass



func exit() :
	pass
