class_name DamageSource
extends Area2D

# --- Variables --- #
## How much damage to deal to intersecting [HpComponent]s
@export var damage := 1

# --- Functions --- #
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is not Hitbox:
		return
	
	# deal damage
	area.take_damage(damage)
