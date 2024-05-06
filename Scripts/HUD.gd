extends CanvasLayer
@onready var CurrentWeaponLabel: Label = $"VBoxContainer/HBoxContainer/Current Weapon"
@onready var CurrentAmmoLabel : Label = $"VBoxContainer/HBoxContainer2/Current Ammo"
@onready var CurrentWeaponStack : Label = $"VBoxContainer/HBoxContainer3/Weapon Stack"

@onready var HealthBar = $HUD
@onready var HUD = $VBoxContainer
@onready var healthbar = $HUD/HealthBar
@onready var player = $".."


func _ready():
	if player.player == multiplayer.get_unique_id():
		HealthBar.show()
		HUD.show()

func _on_weapons_manager_update_ammo(Ammo):
	#if player_name == multiplayer.get_unique_id():
		CurrentAmmoLabel.text=(str(Ammo[0])+ " / " + str(Ammo[1]))

func _on_weapons_manager_update_weapon_stack(Weapon_Stack):
	#if player_name == multiplayer.get_unique_id():
		CurrentWeaponStack.text = "" # Clear the existing text
		for i in Weapon_Stack:
			CurrentWeaponStack.text += "\n" + str(i)

func _on_weapons_manager_weapon_changed(Weapon_Name):
	#if player_name == multiplayer.get_unique_id():
		CurrentWeaponLabel.text=(Weapon_Name)


func _on_playermodel_health_change(health):
	healthbar.value=health
