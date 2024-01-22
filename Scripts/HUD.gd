extends CanvasLayer
@onready var CurrentWeaponLabel: Label = $"VBoxContainer/HBoxContainer/CurrentWeapon"
@onready var CurrentAmmoLabel : Label = $"VBoxContainer/HBoxContainer2/CurrentAmmo"
@onready var CurrentWeaponStack : Label = $VBoxContainer/HBoxContainer3/WeaponStack


func _on_weapons_manager_update_ammo(Ammo):
	CurrentAmmoLabel.text=(str(Ammo[0])+ " / " + str(Ammo[1]))

func _on_weapons_manager_update_weapon_stack(Weapon_Stack):
	CurrentWeaponStack.text = "" # Clear the existing text
	for i in Weapon_Stack:
		CurrentWeaponStack.text += "\n" + str(i)


func _on_weapons_manager_weapon_changed(Weapon_Name):
	CurrentWeaponLabel.text=(Weapon_Name)
