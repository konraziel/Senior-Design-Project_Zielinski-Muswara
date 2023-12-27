extends State

@export var inputvector : Vector3

func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	if inputvector.x== 0 and inputvector.y==0: 
		Transition.emit(self, "idlestate")


func enter():
	pass



func exit() :
	pass
