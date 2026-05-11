class_name SeaMine
extends Node2D

# --- Variables --- #
## How far the pearl can get away from its origin point
const BOB_RANGE := 1.0
## How long it takes for the pearl to get from 1 point to another
const BOB_TIME := 2.0

## The original position this pearl is in. This is used for anchoring the bobbing animation
var origin: Vector2

# --- Functions --- #
func _ready() -> void:
	origin = position

func _process(_delta: float) -> void:
	global_position.x = origin.x + sin(((Time.get_ticks_msec() / 1000.0) + origin.x + origin.y) * BOB_TIME)
