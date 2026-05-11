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

## Sets the game state
func set_game_state(state: GameState) -> void:
	game_state = state

## Reloads the currently loaded game
func reload_game() -> void:
	# hide death panels
	%'death_oxygen'.hide_panel()
	
	# TODO: Add a transition
	
	load_level()

## Reloads the currently loaded game
func open_upgrades() -> void:
	# hide death panels
	%'upgrades'.show_panel()
	
	# TODO: Add a transition

## Loads/Reloads the main level scene and sets up the player
func load_level() -> void:
	if level:
		level.queue_free()
	
	# hide menus
	%'death_oxygen'.hide_panel()
	%'death_health'.hide_panel()
	%'upgrades'.hide_panel()
	
	# reset level
	%'player'.reset()
	
	%'ui'.reset()
	
	await get_tree().create_timer(0.20).timeout
	
	level = MAIN_GAME_SCENE.instantiate()
	level.name = "level"
	
	add_child(level)
	
	# start game
	%'game_timer'.start_timer()
	%'player'.start_game()
	
	set_game_state(GameState.GAMEPLAY)
