class_name Hitbox
extends Area2D

# --- Variables --- #
@export var hp: HpComponent

# --- Functions --- #
## Decreases damage by [param amount]
func take_damage(amount := 1) -> void:
	hp.take_damage(amount)
