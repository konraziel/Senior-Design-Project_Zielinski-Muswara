extends State
@export var input_vector:Vector3

#if inputvector is zero
func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	print(input_vector.x)
	if input_vector.x != 0: 
		Transition.emit(self, "walkingstate")
	if input_vector.z != 0: 
		Transition.emit(self, "walkingstate")


func enter():
	pass



func exit() :
	pass
