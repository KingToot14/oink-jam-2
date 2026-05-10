class_name GameManager
extends Node

# --- Enums --- #
enum GameState {
	MAIN_MENU,
	GAMEPLAY,
	UPGRADES,
}

# --- Variables --- #
const MAIN_GAME_SCENE := preload("res://scenes/main_level.tscn")

var level: Node2D

@export var game_state := GameState.GAMEPLAY

# --- Functions --- #
func _ready() -> void:
	$'game_timer'.timer_ended.connect(reload_game)
	
	reload_game()

## Reloads the currently loaded game
func reload_game() -> void:
	if level:
		level.queue_free()
	
	# reset level
	level = MAIN_GAME_SCENE.instantiate()
	level.name = "level"
	
	add_child(level)
	
	# start game
	$'player'.global_position = Vector2.ZERO
	$'game_timer'.start_timer()
