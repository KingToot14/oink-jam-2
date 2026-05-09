@tool
class_name Pearl
extends Area2D

# --- Enums --- #
## Different pearl types that sell for different prices:
## [br] - WHITE: 1 gold
## [br] - PINK: 10 gold
## [br] - BLACK: 25 gold
enum PearlVariant {
	WHITE,
	PINK,
	BLACK
}

# --- Variables --- #
## The variant of pearl this instance is. This determines the sprite and sell price
@export var variant := PearlVariant.WHITE:
	set(_var):
		variant = _var
		
		$'sprite'.frame = int(variant)

# --- Functions --- #
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&'player'):
		return
	
	# collect pearl
	CurrencyManager.collect_pearl(variant)
	
	# play collection animation
	queue_free()
