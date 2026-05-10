class_name GameManager
extends Node

# --- Enums --- #
## Determines the different sections of the game
enum GameState {
	MAIN_MENU,
	GAMEPLAY,
	DEATH,
	UPGRADES,
}

# --- Variables --- #
## The main level scene used for reloading
const MAIN_GAME_SCENE := preload("res://scenes/main_level.tscn")

## The current instance of the main level scene
var level: Node2D

## The current game state
@export var game_state := GameState.GAMEPLAY

# --- Functions --- #
func _ready() -> void:
	Globals.main = self
	
	reload_game()

## Reloads the currently loaded game
func reload_game() -> void:
	if level:
		level.queue_free()
	
	# hide death panels
	%'death_oxygen'.hide_panel()
	
	# TODO: Add a transition
	
	# reset level
	$'player'.reset()
	
	# TODO: Remove this when the loading system is a bit better. This just stops accidental collection
	await get_tree().create_timer(0.25).timeout
	
	level = MAIN_GAME_SCENE.instantiate()
	level.name = "level"
	
	add_child(level)
	
	# start game
	$'game_timer'.start_timer()
	$'player'.start_game()
	
	set_game_state(GameState.GAMEPLAY)

## Sets the game state
func set_game_state(state: GameState) -> void:
	game_state = state
