extends State



func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	pass
	if Global.player.input_vector.x == 0 and Global.player.input_vector.y==0: 
		Transition.emit(self, "idlestate")
	


func enter():
	pass



func exit() :
	pass
