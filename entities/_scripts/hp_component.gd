class_name HpComponent
extends Node

# --- Signals --- #
signal hp_modified()
signal died()

# --- Variables --- #
@export var max_hp := 1
var curr_hp := 1

var is_dead := false

# --- Functions --- #
func reset() -> void:
	curr_hp = max_hp

func set_max_hp(value: int) -> void:
	max_hp = value
	curr_hp = value

func take_damage(amount := 1) -> void:
	curr_hp -= amount
	
	if curr_hp <= 0:
		died.emit()
		is_dead = false
	
	hp_modified.emit()
