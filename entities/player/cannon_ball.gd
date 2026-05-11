class_name CannonBall
extends CharacterBody2D

# --- Variables --- #
@export var move_speed := 100.0

var broken := false

# --- Functions --- #
func _ready() -> void:
	$'damage_source'.damage_applied.connect(_on_hit)

func _physics_process(delta: float) -> void:
	if broken:
		return
	
	var collision := move_and_collide(velocity * delta)
	
	if collision:
		do_hit()

func _on_hit(_area: Area2D) -> void:
	do_hit()

func do_hit() -> void:
	broken = true
	$'animator'.play(&'break')

## Sets the velocity for the cannon ball
func setup(dir: Vector2, damage: int) -> void:
	velocity = dir * move_speed
	$'damage_source'.damage = damage
