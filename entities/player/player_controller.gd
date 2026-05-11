class_name PlayerController
extends CharacterBody2D

# --- Variables --- #
const WALL_BUMP_POWER := 100.0

## How much [member curr_speed] should be increased relative to the [member move_speed].
## This is applied when a movement input is being pressed.
@export var accel_mod := 2.0
## How much [member curr_speed] should be increased relative to the [member move_speed].
## This is applied when no movement inputs are being pressed.
@export var deccel_mod := 4.0
## The max speed during normal movement.
@export var move_speed := 50.0
## How quickly the sub turns when pressing a turning button
@export var turn_speed := 50.0

## The current speed calculated from the [member accel_mod] and [member deccel_mod]
var curr_speed := 0.0

## Whether or not the sub is currently dashing.
var is_dashing := false

# - External Forces - #
## The total times that each force should last for. This is unmodified until the force
## is done being processed.
var force_times: Dictionary[StringName, float] = {}
## The remaining times that each force should last for. This is modified during each
## physics step
var force_timers: Dictionary[StringName, float] = {}
## The max velocity to be applied for each force. This is weighted by
## [code]force_timers[key] / force_times[key][/code]
var force_vectors: Dictionary[StringName, Vector2] = {}

# - Health - #
@export var hp: HpComponent

# --- Functions --- #
func _ready() -> void:
	Globals.player = self
	
	# setup signals
	hp.hp_modified.connect(hit_flash)

func _physics_process(delta: float) -> void:
	# only move when in gameplay
	if Globals.main.game_state != GameManager.GameState.GAMEPLAY:
		return
	
	# don't move if destroyed
	if hp.is_dead:
		return
	
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
	
	# update acceleration
	if move_dir == 0.0:
		# deccelerate
		if curr_speed < 0.0:
			curr_speed = minf(curr_speed + move_speed * deccel_mod * delta, 0.0)
		if curr_speed > 0.0:
			curr_speed = maxf(curr_speed - move_speed * deccel_mod * delta, 0.0)
	else:
		# accelerate
		curr_speed = clampf(curr_speed + move_speed * accel_mod * delta * move_dir, -move_speed, move_speed)
	
	# do movement
	velocity = Vector2.from_angle(rotation + PI / 2.0) * curr_speed
	
	var total_velocity := get_total_velocity(delta)
	
	var collision := move_and_collide(total_velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		
		# check collision types
		var collider := collision.get_collider()
		
		# if collision is a wall, move away
		if collider is Node and collider.is_in_group(&'wall'):
			var normal := collision.get_normal()
			
			# add impulse
			add_impulse(&'wall', 0.20, normal * WALL_BUMP_POWER)
			
			# adjust angle
			var angle := floori(rotation_degrees + 360) % 360
			
			if normal.x > 0.50:
				if angle < 90 or (angle > 180 and angle < 270):
					rotation_degrees -= 15
				else:
					rotation_degrees += 15
			elif normal.x < -0.50:
				if angle < 90 or (angle > 180 and angle < 270):
					rotation_degrees -= 15
				else:
					rotation_degrees += 15
			elif normal.y > 0.50:
				if angle < 90 or (angle > 180 and angle < 270):
					rotation_degrees += 15
				else:
					rotation_degrees -= 15
			elif normal.y < -0.50:
				if angle < 90 or (angle > 180 and angle < 270):
					rotation_degrees += 15
				else:
					rotation_degrees -= 15

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'fire_cannon'):
		fire_cannon(get_global_mouse_position())

## Resets all components of the player's position and physics. This includes
## rotation, current speed, and impuse forces
func reset() -> void:
	# position
	position = Vector2.ZERO
	rotation = 0
	
	# speed
	velocity = Vector2.ZERO
	curr_speed = 0
	
	# forces
	force_timers = {}
	force_times = {}
	force_vectors = {}
	
	# hp
	hp.reset()
	
	# disable collision
	$'shape'.set_deferred(&'disabled', true)

func start_game() -> void:
	$'shape'.set_deferred(&'disabled', false)

## Fires a single torpedo towards the [member mouse_pos]
func fire_cannon(mouse_pos: Vector2) -> void:
	pass

#region Impulse Forces
## Adds an impuse force to the player submarine. Using the same [param key] will
## override previous forces using that key (useful for continuous forces rather than
## impulses)
func add_impulse(key: StringName, time: float, force: Vector2) -> void:
	force_times[key] = time
	force_timers[key] = time
	force_vectors[key] = force

## Returns the total velocity as a sum of the base movement velocity plus all of the
## [member force_vectors]. These force vectors are weighted by their remaining
## [member force_timers].
func get_total_velocity(delta: float) -> Vector2:
	var total_velocity := velocity
	var keys := force_times.keys()
	
	for key in keys:
		total_velocity += force_vectors[key] * (force_timers[key] / force_times[key])
		
		# decrement timers
		force_timers[key] -= delta
		
		# remove forces
		if force_timers[key] <= 0.0:
			force_times.erase(key)
			force_timers.erase(key)
			force_vectors.erase(key)
	
	return total_velocity

#endregion

#region Health System
func hit_flash() -> void:
	$'sprite'.material.set_shader_parameter(&'intensity', 1.0)
	
	var tween := create_tween()
	tween.tween_method(func (x): $'sprite'.material.set_shader_parameter(&'intensity', x), 1.0, 0.0, 0.20)

#endregion
