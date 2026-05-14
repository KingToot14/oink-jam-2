class_name GameTimer
extends Node

# --- Signals --- #
signal timer_ended()
signal timer_updated(sec: int)

# --- Variables --- #
var running := false

@export var run_time := 10.0
var run_timer := 0.0
var curr_sec := 0.0

# --- Functions --- #
func _ready() -> void:
	Globals.timer = self

func _process(delta: float) -> void:
	if not running or Globals.main.game_state != GameManager.GameState.GAMEPLAY:
		return
	
	run_timer -= delta * %'player'.get_depth_mod()
	
	# check if a new second was reached
	var sec := ceili(run_timer)
	
	if sec < curr_sec:
		curr_sec = sec
		timer_updated.emit(curr_sec)
	
	# check if the player ran out of time
	if run_timer <= 0.0:
		running = false
		timer_ended.emit()

## Starts the game timer
func start_timer() -> void:
	# fetch upgrades
	run_time = ceili(Upgrades.get_upgrade_value(&'hull_capacity'))
	
	# start timer
	run_timer = run_time
	curr_sec = ceili(run_time)
	running = true
	
	timer_updated.emit(curr_sec)
