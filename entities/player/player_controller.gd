class_name PlayerController
extends CharacterBody2D

# --- Variables --- #
@export var move_speed := 50.0
@export var turn_speed := 50.0

var is_dashing := false

# --- Functions --- #
func _physics_process(delta: float) -> void:
	# check dash
	is_dashing = Input.is_action_pressed(&'do_dash')
	
	# check movement
	var move_dir := Input.get_axis(&'move_backward', &'move_forward')
	var turn_dir := Input.get_axis(&'turn_left', &'turn_right')
	
	# update direction
	if move_dir < 0.0:
		rotation_degrees -= turn_dir * turn_speed * delta
	else:
		rotation_degrees += turn_dir * turn_speed * delta
	
	velocity = Vector2.from_angle(rotation + PI / 2.0) * move_speed * move_dir
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'fire_cannon'):
		fire_cannon(get_global_mouse_position())

func fire_cannon(mouse_pos: Vector2) -> void:
	pass
