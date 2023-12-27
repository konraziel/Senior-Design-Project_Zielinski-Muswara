# Virtual base class for all states.
class_name State
extends Node


signal Transition

func update(_delta: float) :
	pass



func physics_update(_delta: float) :
	pass


func enter():
	pass



func exit() :
	pass
