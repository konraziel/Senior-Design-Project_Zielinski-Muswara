extends Node3D

@onready var Animation_Player = $FPS_Rig/AnimationGuns
var Current_Weapon = null
var Weapon_Stack = [] # An Array of Weapons Currently Held by the Player
var Weapon_Indicator = 0

var Next_Weapon : String

var Weapon_List = {}

@export var _weapon_resources: Array[Weapon_Resource]
@export var Start_Weapons: Array[String]

func _ready():
	Initialize(Start_Weapons)
func _input(event):
	if event.is_action_pressed('Weapon_UP'):
		Weapon_Indicator = min(Weapon_Indicator+1,Weapon_Stack.size()-1)
		_exit(Weapon_Stack[Weapon_Indicator])
	if event.is_action_pressed('Weapon_DOWN'):
		Weapon_Indicator = max(Weapon_Indicator-1,0)
		_exit(Weapon_Stack[Weapon_Indicator])
	
func Initialize(_Start_Weapons: Array):
	for weapon in _weapon_resources:
		Weapon_List[weapon.Weapon_Name]= weapon
	for i in _Start_Weapons:
		Weapon_Stack.push_back(i) # Add our start weapons

	Current_Weapon = Weapon_List[Weapon_Stack[0]] # set the first weapon in the stack to current
	_enter()

func _enter():
	Animation_Player.queue(Current_Weapon.Activate_Anim)

func _exit(_next_weapon : String):
	if _next_weapon != Current_Weapon.Weapon_Name:
		if Animation_Player.get_current_animation() != Current_Weapon.Deactivate_Anim:
			Animation_Player.play(Current_Weapon.Deactivate_Anim)
			Next_Weapon=_next_weapon

func Change_Weapon(weapon_name:String):
	Current_Weapon=Weapon_List[weapon_name]
	Next_Weapon=''
	_enter()


func _on_animation_guns_animation_finished(anim_name):
	if anim_name == Current_Weapon.Deactivate_Anim:
		Change_Weapon(Next_Weapon)
