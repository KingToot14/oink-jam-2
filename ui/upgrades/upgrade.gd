class_name Upgrade
extends Resource

# --- Variables --- #
## Determines whether or not this upgrade is unlocked
@export var unlocked := true
## The value to return when this upgrade is not locked
@export var locked_value := 1.0

## The upgrade name
@export var name: String
## The current upgrade level (should be set to 1 in the inspector)
@export var level := 1
## The maximum level that this upgrade can be upgraded to
@export var max_level := 10

## The icon to be used in the upgrade menu
@export var icon: Texture2D

## Whether or not the upgrade value should be calculated exponentially (
## [code]base_value * value_exponent ** (level - 1)[/code]) or linearly (
## [code]base_value + value_exponent * (level - 1)[/code]
@export var is_value_linear := false
## The base value this upgrade should hold (at level 1)
@export var base_value := 1.0
## How much this upgrade's value should increase by (dependent on [member is_value_linear]
@export var value_exponent := 1.5

## Whether or not the upgrade cost should be calculated exponentially (
## [code]base_cost * cost_exponent ** (level - 1)[/code]) or linearly (
## [code]base_cost + cost_exponent * (level - 1)[/code]
@export var is_cost_linear := false
## The base cost this upgrade should hold (at level 1)
@export var base_cost := 5
## How much this upgrade's cost should increase by (dependent on [member is_cost_linear]
@export var cost_exponent := 1.5

# --- Functions --- #
## Gets the current value of this upgrade based on [member level]
func get_value() -> float:
	# check if unlocked
	if not unlocked:
		return locked_value
	
	if is_value_linear:
		return base_value + value_exponent * (level - 1)
	else:
		return base_value * value_exponent ** (level - 1)

## Gets the current cost of this upgrade based on [member level]
func get_cost() -> int:
	if is_cost_linear:
		return ceili(base_cost + cost_exponent * (level - 1))
	else:
		return ceili(base_cost * cost_exponent ** (level - 1))

## Tries to increase the level of this upgrade. This fails if the player
## doesn't have enough gold, or if the upgrade is already maxed
func try_upgrade_level() -> bool:
	# make sure upgrade is unlocked
	if not unlocked:
		return false
	
	# make sure upgrade is not maxed
	if level >= max_level:
		return false
	
	# make sure player has enough gold
	if CurrencyManager.curr_gold < get_cost():
		return false
	
	# do upgrade
	CurrencyManager.remove_gold(get_cost())
	level += 1
	
	return true
