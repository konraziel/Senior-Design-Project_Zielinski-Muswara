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
func Initialize(_Start_Weapons: Array):
	for weapon in _weapon_resources:
		Weapon_List[weapon.Weapon_Name]= weapon
	for i in _Start_Weapons:
		Weapon_Stack.push_back(i) # Add our start weapons

	Current_Weapon = Weapon_List[Weapon_Stack[0]] # set the first weapon in the stack to current


func _enter():
	Animation_Player.queue(Current_Weapon.Activate_Anim)

func _exit():
	# in order to change weapons first call exit
	pass

func Change_Weapon():
	pass
