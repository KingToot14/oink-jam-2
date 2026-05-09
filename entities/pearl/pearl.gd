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
const BOB_RANGE := 1.0
const BOB_TIME := 2.0

## The variant of pearl this instance is. This determines the sprite and sell price
@export var variant := PearlVariant.WHITE:
	set(_var):
		variant = _var
		
		$'sprite'.frame = int(variant)

## The original position this pearl is in. This is used for anchoring the bobbing animation
var origin: Vector2

# --- Functions --- #
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	origin = position
	do_bob()

func do_bob() -> void:
	var new_pos := origin + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * BOB_RANGE
	
	var tween := create_tween()
	
	tween.tween_property(self, ^'position', new_pos, BOB_TIME)
	
	await tween.finished
	
	do_bob()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&'player'):
		return
	
	# collect pearl
	CurrencyManager.collect_pearl(variant)
	
	# play collection animation
	queue_free()
