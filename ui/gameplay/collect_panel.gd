class_name CollectPanel
extends Control

# --- Variables --- #
## How long the [method show_panel] and [method hide_panel] tweens take to run.
const TWEEN_TIME := 0.15

## The original y position of this panel
var origin: float

# --- Functions --- #
func _ready() -> void:
	Globals.collect_panel = self
	
	# store origin
	origin = position.y
	
	# hide panel originally
	hide()

## Loads information about a [Collect]
func load_collect_info(collect: Collect) -> void:
	$'name'.text = collect.name
	$'description'.text = collect.description
	
	$'icon_holder/icon'.texture = collect.icon
	
	show_panel()

## Shows the panel by animating it using tweening
func show_panel() -> void:
	# stop timer
	%'game_timer'.running = false
	Globals.main.set_game_state(GameManager.GameState.PAUSED)
	
	# show panel
	modulate.a = 0.0
	position.y = origin + 8
	show()
	
	var tween := create_tween().set_parallel()
	
	tween.tween_property(self, ^'modulate:a', 1.0, TWEEN_TIME)
	tween.tween_property(self, ^'position:y', origin, TWEEN_TIME)

## Hides the panel by animating it using tweening
func hide_panel() -> void:
	# resume timer
	%'game_timer'.running = true
	Globals.main.set_game_state(GameManager.GameState.GAMEPLAY)
	
	var tween := create_tween().set_parallel()
	
	tween.tween_property(self, ^'modulate:a', 0.0, TWEEN_TIME)
	tween.tween_property(self, ^'position:y', origin + 8, TWEEN_TIME)
	
	tween.finished.connect(hide)
