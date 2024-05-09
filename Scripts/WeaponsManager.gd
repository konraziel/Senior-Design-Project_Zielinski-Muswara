extends Node3D

signal elimination

signal Weapon_Changed
signal Update_Ammo
signal Update_Weapon_Stack

@onready var Animation_Player = $FPS_Rig/AnimationGuns
var Current_Weapon = null
var Weapon_Stack = [] # An Array of Weapons Currently Held by the Player
var Weapon_Indicator = 0

var Next_Weapon : String

var Weapon_List = {}

@export var _weapon_resources: Array[Weapon_Resource]
@export var Start_Weapons: Array[String]
@onready var Bullet_Point = $FPS_Rig/Bullet_Point
@onready var input = $"../../../PlayerInput"
@onready var player = $"../../.."

enum {NULL, HITSCAN, PROJECTILE}

func _ready():
	Initialize.rpc(Start_Weapons)
		
	set_process(multiplayer.is_server())

#func _input(event):
	#if get_multiplayer_authority() == multiplayer.get_unique_id():
	#
		#if event.is_action_pressed('Weapon_UP'):
			#Weapon_Indicator = min(Weapon_Indicator+1,Weapon_Stack.size()-1)
			#_exit.rpc(Weapon_Stack[Weapon_Indicator])
		#if event.is_action_pressed('Weapon_DOWN'):
			#Weapon_Indicator = max(Weapon_Indicator-1,0)
			#_exit.rpc(Weapon_Stack[Weapon_Indicator])
		#if event.is_action_pressed('Shoot'):
			#shoot.rpc()
		#if event.is_action_pressed('Reload'):
			#reload.rpc()

func _process(delta):
	if input.wheel_up:
		Weapon_Indicator = min(Weapon_Indicator+1,Weapon_Stack.size()-1)
		_exit.rpc(Weapon_Stack[Weapon_Indicator])
	if input.wheel_down:
		Weapon_Indicator = max(Weapon_Indicator-1,0)
		_exit.rpc(Weapon_Stack[Weapon_Indicator])
	if input.shooting:
		shoot.rpc()
	if input.reloading:
		reload.rpc()
	
	input.wheel_up = false
	input.wheel_down = false
	input.shooting = false
	input.reloading = false

@rpc("call_local")
func Initialize(_Start_Weapons: Array):
	for weapon in _weapon_resources:
		Weapon_List[weapon.Weapon_Name]= weapon
	for i in _Start_Weapons:
		Weapon_Stack.push_back(i) # Add our start weapons

	Current_Weapon = Weapon_List[Weapon_Stack[0]] # set the first weapon in the stack to current
	emit_signal("Update_Weapon_Stack", Weapon_Stack)
	_enter.rpc()

@rpc("call_local")
func _enter():
	#print(str(get_multiplayer_authority()))
	Animation_Player.play(Current_Weapon.Activate_Anim)
	emit_signal("Weapon_Changed", Current_Weapon.Weapon_Name)
	emit_signal("Update_Ammo", [Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])

@rpc("call_local")
func _exit(_next_weapon : String):
	if _next_weapon != Current_Weapon.Weapon_Name:
		if Animation_Player.get_current_animation() != Current_Weapon.Deactivate_Anim:
			Animation_Player.play(Current_Weapon.Deactivate_Anim)
			Next_Weapon=_next_weapon

@rpc("call_local")
func Change_Weapon(weapon_name:String):
	var Weapon_Index = Weapon_Stack.find(weapon_name)
	if Weapon_Index != -1:
		Current_Weapon=Weapon_List[weapon_name]
		Next_Weapon=''
		_enter.rpc()

func _on_animation_guns_animation_finished(anim_name):
	if anim_name == Current_Weapon.Deactivate_Anim:
		Change_Weapon.rpc(Next_Weapon)
	if anim_name == Current_Weapon.Shoot_Anim && Current_Weapon.Auto_Fire==true:
		if Input.is_action_pressed("Shoot"):
			shoot.rpc()

func _on_animation_guns_animation_started(anim_name):
	playAnimRemotely.rpc(anim_name)

@rpc("any_peer", "call_remote")
func playAnimRemotely(anim_name):
	if anim_name == Current_Weapon.Shoot_Anim:
		Animation_Player.play(Current_Weapon.Shoot_Anim)
	elif anim_name == Current_Weapon.Reload_Anim:
		Animation_Player.play(Current_Weapon.Reload_Anim)

@rpc("call_local")
func shoot():
	if player.player == multiplayer.get_unique_id():
		if Current_Weapon.Current_Ammo != 0:
			if !Animation_Player.is_playing():
				Animation_Player.play(Current_Weapon.Shoot_Anim)
				Current_Weapon.Current_Ammo -= 1
				emit_signal("Update_Ammo", [Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
				var Camera_Collision = Get_Camera_Collision()
				match Current_Weapon.Type:
					NULL:
						print("Weapon Tpye Not Chosen")
					HITSCAN:
						Hit_Scan_Collision(Camera_Collision)
					PROJECTILE:
						pass

@rpc("call_local")
func reload():
	if player.player == multiplayer.get_unique_id():
		if Current_Weapon.Current_Ammo ==Current_Weapon.Magazine:
			return
		elif !Animation_Player.is_playing():
			if Current_Weapon.Reserve_Ammo!= 0:
				Animation_Player.play(Current_Weapon.Reload_Anim)
				var Reload_Amount =min(Current_Weapon.Magazine - Current_Weapon.Current_Ammo, Current_Weapon.Magazine, Current_Weapon.Reserve_Ammo)
			
				Current_Weapon.Current_Ammo = Current_Weapon.Current_Ammo +Reload_Amount
				#Current_Weapon.Reserve_Ammo = Current_Weapon.Reserve_Ammo - Reload_Amount
				emit_signal("Update_Ammo", [Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
			else:
				Animation_Player.play(Current_Weapon.Out_Of_Ammo_Anim) 
				
		Animation_Player.play(Current_Weapon.Reload_Anim)

func Get_Camera_Collision()->Vector3:
	var camera= get_viewport().get_camera_3d()
	var viewport =get_viewport().get_size()
	var Ray_Origin = camera.project_ray_origin(viewport/2)
	var Ray_End = Ray_Origin + camera.project_ray_normal(viewport/2)*Current_Weapon.Weapon_Range
	var New_Intersection =PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	var Intersection = get_world_3d().direct_space_state.intersect_ray(New_Intersection)
	
	if not Intersection.is_empty():
		var Col_Point=Intersection.position
		return Col_Point
	else:
		return Ray_End

func Hit_Scan_Collision(Collision_Point):
	#if not is_multiplayer_authority(): return
	var Bullet_Direction = (Collision_Point - Bullet_Point.get_global_transform().origin).normalized()
	var New_Interaction = PhysicsRayQueryParameters3D.create(Bullet_Point.get_global_transform().origin, Collision_Point+Bullet_Direction*2)
	var Bullet_Collision = get_world_3d().direct_space_state.intersect_ray(New_Interaction)
	
	if Bullet_Collision:
		print(multiplayer.get_unique_id()," shot ", Bullet_Collision.collider, " ", multiplayer.is_server())
		Hit_Scan_Damage(Bullet_Collision.collider)

func Hit_Scan_Damage(Collider):
	if Collider.is_in_group("Target") and Collider.has_method("Hit_Success"):
		if Collider.Health == 1:
			emit_signal("elimination")
		Collider.Hit_Success.rpc(Current_Weapon.Damage)
