class_name StateMachine
extends Node

@export var initial_state : State

var current_state : State
var states :Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state
func _process(delta):
	if current_state:
		current_state.update(delta) 
		
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
func on_child_transition(state,new_stae_name):
	if state != current_state:
		return 
	var new_state = states.get(new_stae_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state=new_state 
