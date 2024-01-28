extends RigidBody3D

var Health=5

func Hit_Success(Damage):
	Health-= Damage
	print("hit successful")
	if Health<= 0:
		queue_free()
