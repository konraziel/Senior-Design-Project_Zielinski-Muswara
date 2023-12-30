extends State

@export var input_vector:Vector3

func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	print(input_vector.x)
	if input_vector.x == 0 and input_vector.y==0: 
		Transition.emit(self, "idlestate")
	


func enter():
	pass



func exit() :
	pass
