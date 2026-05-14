class_name GameManager
extends Node

# --- Enums --- #
## Determines the different sections of the game
enum GameState {
	MAIN_MENU,
	GAMEPLAY,
	DEATH,
	UPGRADES,
	PAUSED,
}

# --- Variables --- #
## The main level scene used for reloading
const MAIN_GAME_SCENE := preload("res://scenes/main_level.tscn")

## The current instance of the main level scene
var level: Node2D

## The current game state
@export var game_state := GameState.MAIN_MENU

# --- Functions --- #
func _ready() -> void:
	Globals.main = self

## Sets the game state
func set_game_state(state: GameState) -> void:
	game_state = state

## Reloads the currently loaded game
func reload_game() -> void:
	load_level()

## Reloads the currently loaded game
func open_upgrades() -> void:
	# hide death panels
	%'upgrades'.show_panel()
	
	# TODO: Add a transition

## Loads/Reloads the main level scene and sets up the player
func load_level() -> void:
	# play transition
	%'game_transitions'.tween_intensity(1.0, 0.50)
	
	# hide menus
	%'death_oxygen'.hide_panel()
	%'death_health'.hide_panel()
	%'upgrades'.hide_panel()
	
	await get_tree().create_timer(1.00).timeout
	
	# hide title
	$'ui/title'.hide()
	
	# reset level
	%'player'.reset()
	%'ui'.reset()
	
	if level:
		level.queue_free()
	
	level = MAIN_GAME_SCENE.instantiate()
	level.name = "level"
	
	add_child(level)
	
	# tween transition
	%'game_transitions'.tween_intensity(0.0, 0.50)
	
	await get_tree().create_timer(0.50).timeout
	
	# start game
	%'game_timer'.reset_timer()
	%'player'.start_game()
	
	set_game_state(GameState.GAMEPLAY)
