class_name GameTimer
extends Node

# --- Signals --- #
signal timer_ended()

# --- Variables --- #
var running := false

@export var run_time := 10.0
var run_timer := 0.0

# --- Functions --- #
func _process(delta: float) -> void:
	if not running:
		return
	
	run_timer -= delta
	
	# check if the player ran out of time
	if run_timer <= 0.0:
		running = false
		timer_ended.emit()

## Starts the game timer
func start_timer() -> void:
	run_timer = run_time
	running = true
