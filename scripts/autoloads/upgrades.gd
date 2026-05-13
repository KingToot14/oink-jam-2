extends Node

# --- Variables --- #
## Maps upgrade resources to a key. Used in the [method get_upgrade_value] method
var upgrades: Dictionary[StringName, Upgrade] = {}

# --- Functions --- #
func _ready() -> void:
	# dynamically map upgrades to keys
	for file: String in DirAccess.get_files_at("res://resources/upgrades"):
		if file.ends_with(".gd"):
			continue
		
		upgrades[file.split('.')[0]] = load("res://resources/upgrades".path_join(file))

## Gets the current value of the upgrade identified by [param upgrade_key]. This
## uses [method Upgrade.get_value] to get the correct value
func get_upgrade_value(upgrade_key: StringName) -> float:
	if upgrade_key not in upgrades.keys():
		return 0.0
	
	return upgrades[upgrade_key].get_value()
