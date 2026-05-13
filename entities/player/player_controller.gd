class_name PlayerController
extends CharacterBody2D

# --- Signals --- #
signal dash_used()
signal cannon_fired()

# --- Variables --- #
const WALL_BUMP_POWER := 100.0
const CANNON_BALL_SCENE := preload("res://entities/player/cannon_ball.tscn")

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
## The [HpComponent] that the player uses to manage health
@export var hp: HpComponent

# - Dashing - #
## Whether or not the sub is currently dashing.
var is_dashing := false

## How much the base speed is multiplied by when dashing
@export var dash_increase := 1.5

## The max amount of time that the player can dash for
@export var max_dash_time := 5.0
## The remaining time that hte player can dash for
var dash_time := 5.0

# - Ammo - #
## The max number of times that the player can fire cannon balls
@export var max_ammo := 1
## The remaining number of times that the player can fire cannon balls
var curr_ammo := 1

## How much damage the cannon balls should do
var cannon_damage := 1

# - Depth - #
## The maximum depth the sub can be before taking penalties
@export var max_depth := 1
## The current depth the sub is located at
var curr_depth := 1

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
	if abs(move_dir) <= 0.10:
		# deccelerate
		if curr_speed < 0.0:
			curr_speed = minf(curr_speed + move_speed * deccel_mod * delta, 0.0)
		if curr_speed > 0.0:
			curr_speed = maxf(curr_speed - move_speed * deccel_mod * delta, 0.0)
	else:
		# accelerate
		if is_dashing and dash_time > 0.0:
			curr_speed += move_speed * accel_mod * delta * move_dir * dash_increase
			
			if curr_speed > move_speed * dash_increase:
				curr_speed = maxf(curr_speed - move_speed * deccel_mod * delta, move_speed * dash_increase)
			if curr_speed < -move_speed * dash_increase:
				curr_speed = minf(curr_speed + move_speed * deccel_mod * delta, -move_speed * dash_increase)
			
			# reduce dash timer
			dash_time = maxf(dash_time - delta, 0.0)
			
			dash_used.emit()
		else:
			curr_speed += move_speed * accel_mod * delta * move_dir
			
			if curr_speed > move_speed:
				curr_speed = maxf(curr_speed - move_speed * deccel_mod * delta, move_speed)
			if curr_speed < -move_speed:
				curr_speed = minf(curr_speed + move_speed * deccel_mod * delta, -move_speed)
	
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
	
	# check depth
	if global_position.y > 1352.0:
		curr_depth = 3
	elif global_position.y > 768.0:
		curr_depth = 2
	else:
		curr_depth = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&'fire_cannon'):
		fire_cannon(get_global_mouse_position())

## Resets all components of the player's position and physics. This includes
## rotation, current speed, and impuse forces
func reset() -> void:
	# fetch upgrades
	hp.set_max_hp(floori(Upgrades.get_upgrade_value(&'hull_strength')))
	
	move_speed = Upgrades.get_upgrade_value(&'propeller_blades')
	turn_speed = Upgrades.get_upgrade_value(&'propeller_body')
	
	dash_increase = Upgrades.get_upgrade_value(&'jet_thrust')
	max_dash_time = Upgrades.get_upgrade_value(&'jet_capacity')
	
	max_ammo = floori(Upgrades.get_upgrade_value(&'cannon_capacity'))
	cannon_damage = floori(Upgrades.get_upgrade_value(&'cannon_power'))
	
	max_depth = floori(Upgrades.get_upgrade_value(&'max_depth'))
	
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
	
	# dashing
	dash_time = max_dash_time
	
	# cannon
	curr_ammo = max_ammo
	$'cannon'.rotation = 0.0
	
	# disable collision
	$'shape'.set_deferred(&'disabled', true)

func start_game() -> void:
	$'shape'.set_deferred(&'disabled', false)

## Fires a single torpedo towards the [member mouse_pos]
func fire_cannon(mouse_pos: Vector2) -> void:
	# don't fire if animating
	if $'cannon/animator'.is_playing():
		return
	
	# don't fire if not in gameplay
	if Globals.main.game_state != GameManager.GameState.GAMEPLAY:
		return
	
	# don't fire if no ammo remains
	if curr_ammo <= 0:
		return
	
	var direction := (mouse_pos - global_position).normalized()
	var angle := atan2(direction.y, direction.x)
	
	# play fire animation
	$'cannon'.global_rotation = angle - PI / 2.0
	$'cannon/animator'.play(&'fire')
	
	# create cannon ball
	var ball: CannonBall = CANNON_BALL_SCENE.instantiate()
	ball.global_position = $'cannon/fire_point'.global_position
	ball.setup(direction, cannon_damage)
	
	get_tree().current_scene.add_child(ball)
	
	curr_ammo -= 1
	
	# emit signal
	cannon_fired.emit()

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
## Plays a simple flash animation using the sprite's [ShaderMaterial]
func hit_flash() -> void:
	$'sprite'.material.set_shader_parameter(&'intensity', 1.0)
	
	var tween := create_tween()
	tween.tween_method(func (x): $'sprite'.material.set_shader_parameter(&'intensity', x), 1.0, 0.0, 0.20)

#endregion

#region Dashing
## Returns how much of the dash is currently used
func get_dash_percent() -> float:
	if max_dash_time == 0.0:
		return 0.0
	
	return dash_time / max_dash_time

#endregion

#region Depth
## Returns how much the timer should be accelerated by based on [member curr_depth] and
## [member max_depth]
func get_depth_mod() -> float:
	if curr_depth <= max_depth:
		return 1
	
	# 1 away = 1x, 2 away = 2x
	return 1.8 * (2.0 ** (curr_depth - max_depth - 1))

#endregion
