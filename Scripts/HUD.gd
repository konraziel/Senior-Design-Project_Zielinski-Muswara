extends CanvasLayer
@onready var CurrentWeaponLabel: Label = $"VBoxContainer/HBoxContainer/Current Weapon"
@onready var CurrentAmmoLabel : Label = $"VBoxContainer/HBoxContainer2/Current Ammo"
@onready var CurrentWeaponStack : Label = $"VBoxContainer/HBoxContainer3/Weapon Stack"


func _on_weapons_manager_update_ammo(Ammo):
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		CurrentAmmoLabel.text=(str(Ammo[0])+ " / " + str(Ammo[1]))

func _on_weapons_manager_update_weapon_stack(Weapon_Stack):
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		CurrentWeaponStack.text = "" # Clear the existing text
		for i in Weapon_Stack:
			CurrentWeaponStack.text += "\n" + str(i)

func _on_weapons_manager_weapon_changed(Weapon_Name):
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		CurrentWeaponLabel.text=(Weapon_Name)
