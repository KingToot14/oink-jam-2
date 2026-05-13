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
## How far the pearl can get away from its origin point
const BOB_RANGE := 1.0
## How long it takes for the pearl to get from 1 point to another
const BOB_TIME := 2.0

## Whether or not this pearl is currently collected
var collected := false

## The different sparkle sprite for each [enum PearlVariant]
@export var sparkle_variants: Dictionary[PearlVariant, Texture2D] = {}

## The variant of pearl this instance is. This determines the sprite and sell price
@export var variant := PearlVariant.WHITE:
	set(_var):
		variant = _var
		
		setup_variant()

## The original position this pearl is in. This is used for anchoring the bobbing animation
var origin: Vector2

## The collect info that displays the first time the player collects a pearl
@export var pearl_info: Collect

# --- Functions --- #
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	body_entered.connect(_on_body_entered)
	setup_variant()
	
	origin = position

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	global_position.y = origin.y + sin(((Time.get_ticks_msec() / 1000.0) + origin.x + origin.y) * BOB_TIME)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&'player'):
		return
	
	# don't collect twice
	if collected:
		return
	
	# collect pearl
	collected = true
	CurrencyManager.collect_pearl(variant)
	
	# show first collection info
	if not Globals.pearl_collected:
		Globals.collect_panel.load_collect_info(pearl_info)
		Globals.pearl_collected = true
	
	# play collection sfx
	$'sfx'.play_sfx(&'collect')
	
	# play collection animation
	$'particles'.emitting = true
	
	var tween := create_tween().set_parallel()
	
	tween.tween_property(self, ^'scale', Vector2.ZERO, 0.15)
	tween.tween_property(self, ^'global_position', Globals.player.global_position, 0.15)
	
	await get_tree().create_timer(1.0).timeout
	
	# free pearl
	queue_free()

## Sets up the texture and particles for the set variant
func setup_variant() -> void:
	$'sprite'.frame = int(variant)
	$'particles'.texture = sparkle_variants[variant]
