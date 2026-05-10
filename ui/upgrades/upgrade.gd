class_name Upgrade
extends Resource

# --- Variables --- #
@export var name: String
@export var level := 1
@export var max_level := 10

@export var base_value := 1.0
@export var value_exponent := 1.5

@export var base_cost := 5
@export var cost_exponent := 1.5

# --- Functions --- #
func get_value() -> float:
	return base_value * value_exponent ** (level - 1)

func get_cost() -> int:
	return ceili(base_cost * cost_exponent ** (level - 1))

func try_upgrade_level() -> bool:
	# make sure player has enough gold
	if CurrencyManager.curr_gold < get_cost():
		return false
	
	# make sure upgrade is not maxed
	if level >= max_level:
		return false
	
	# do upgrade
	CurrencyManager.remove_gold(get_cost())
	level += 1
	
	return true
