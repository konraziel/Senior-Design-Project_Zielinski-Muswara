extends State


#if inputvector is zero
func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	#pass
	if Global.player.velocity.length() != 0: 
		Transition.emit(self, "walkingstate")



func enter():
	pass



func exit() :
	pass
