class_name UpgradeManager
extends Control

# --- Variables --- #
## How long the [method show_panel] and [method hide_panel] tweens take to run.
const TWEEN_TIME := 0.15

## The original y position of this panel
var origin: float

# --- Functions --- #
func _ready() -> void:
	# set up signals
	CurrencyManager.gold_updated.connect(_on_gold_updated)
	
	# store origin
	origin = position.y

	# hide panel originally
	hide()

func _on_gold_updated() -> void:
	$'gold_holder/gold_label'.text = "%s" % CurrencyManager.curr_gold

#region Visuals
## Shows the panel by animating it using tweening
func show_panel() -> void:
	# update currency
	$'gold_holder/gold_label'.text = "%s" % CurrencyManager.curr_gold
	
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

#endregion
