@tool
class_name Collectable
extends Area2D

# --- Enums --- #
enum SpriteType {
	HULL_1,
	HULL_2,
	DASH,
	CANNON
}

# --- Variables --- #
## How far the collectable can get away from its origin point
const BOB_RANGE := 1.0
## How long it takes for the collectable to get from 1 point to another
const BOB_TIME := 2.0

## The upgrade that this collectable modifies
@export var upgrades: Array[Upgrade] = []
## What level this collectable upgrades to. A value of [code]-1[/code] unlocks the upgrade
@export var upgrade_level := -1

## Whether or not this collectable is currently collected
var collected := false

## The original position this collectable is in. This is used for anchoring the bobbing animation
var origin: Vector2

## Determines what sprite to display
@export var variant := SpriteType.HULL_1:
	set(_var):
		variant = _var
		setup_variant()
## Maps [enum SpriteType] to a texture to display
@export var variant_sprites: Dictionary[SpriteType, Texture2D] = {}

# --- Functions --- #
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	# hide if upgrade is already unlocked
	for upgrade in upgrades:
		if upgrade_level == -1 and upgrade.unlocked:
			queue_free()
			return
		if upgrade_level > 0 and upgrade.level >= upgrade_level:
			queue_free()
			return
	
	body_entered.connect(_on_body_entered)
	setup_variant()
	
	origin = position

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	rotation_degrees = sin(Time.get_ticks_msec() / 1000.0) * 30

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&'player'):
		return
	
	# don't collect twice
	if collected:
		return
	
	# collect collectable
	collected = true
	
	for upgrade in upgrades:
		if upgrade_level == -1:
			upgrade.unlocked = true
		elif upgrade_level > upgrade.level:
			upgrade.level = upgrade_level
	
	# reload unlocks
	Globals.player.reload_unlocked()
	
	# play collection animation
	$'particles'.emitting = true
	
	var tween := create_tween().set_parallel()
	
	tween.tween_property(self, ^'scale', Vector2.ZERO, 0.15)
	tween.tween_property(self, ^'global_position', Globals.player.global_position, 0.15)
	
	await get_tree().create_timer(1.0).timeout
	
	# free collectable
	queue_free()

## Sets up the sprite to the correct collectable
func setup_variant() -> void:
	$'sprite'.texture = variant_sprites[variant]
