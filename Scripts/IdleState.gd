extends State
@export var inputvector:Vector3

#if inputvector is zero
func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	if inputvector.x != 0 or inputvector.y!=0: 
		Transition.emit(self, "walkingstate")


func enter():
	pass



func exit() :
	pass
