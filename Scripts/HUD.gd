extends CanvasLayer
signal respawn
@onready var CurrentWeaponLabel: Label = $"VBoxContainer/HBoxContainer/Current Weapon"
@onready var CurrentAmmoLabel : Label = $"VBoxContainer/HBoxContainer2/Current Ammo"
@onready var CurrentWeaponStack : Label = $"VBoxContainer/HBoxContainer3/Weapon Stack"

@onready var HUD = $HUD
@onready var WeaponHUD = $VBoxContainer
@onready var healthbar = $HUD/HealthBar
@onready var player = $".."
@onready var Counter = $HUD/Counter

var elapsed_time = 0.0  # Tracks the time elapsed since the last increment


func _process(delta):
	# Call a function and pass the delta value as an argument
	counter(delta)

func counter(_delta):
	
	while (Counter.value!=100):
# Increment the elapsed time by the time delta
		elapsed_time += _delta

	# Check if a second has passed
		if elapsed_time >= 1.0:
			# Increment the counter
			Counter.value += 20 
			elapsed_time = 0.0
	


func _ready():
	if player.player == multiplayer.get_unique_id():
		HUD.show()
		WeaponHUD.show()

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


func _on_playermodel_respawn():
	Counter.show()
	healthbar.value=5
	emit_signal("respawn")
