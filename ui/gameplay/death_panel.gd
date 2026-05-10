class_name DeathPanel
extends Control

# --- Variables --- #
## How long the [method show_panel] and [method hide_panel] tweens take to run.
const TWEEN_TIME := 0.15

## The original y position of this panel
var origin: float

# --- Functions --- #
func _ready() -> void:
	# store origin
	origin = position.y
	
	# hide panel originally
	hide()

## Shows the panel by animating it using tweening
func show_panel() -> void:
	# update counters
	$'white_holder/white_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.WHITE]
	$'pink_holder/pink_label'.text   = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.PINK]
	$'black_holder/black_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.BLACK]
	
	# show panel
	modulate.a = 0.0
	position.y = origin + 8
	show()
	
	var tween := create_tween().set_parallel()
	
	tween.tween_property(self, ^'modulate:a', 1.0, TWEEN_TIME)
	tween.tween_property(self, ^'position:y', origin, TWEEN_TIME)

## Hides the panel by animating it using tweening
func hide_panel() -> void:
	var tween := create_tween().set_parallel()
	
	tween.tween_property(self, ^'modulate:a', 0.0, TWEEN_TIME)
	tween.tween_property(self, ^'position:y', origin + 8, TWEEN_TIME)
	
	tween.finished.connect(hide)
