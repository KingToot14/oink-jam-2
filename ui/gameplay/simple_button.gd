class_name SimpleButton
extends BaseButton

# --- Variables --- #
## The color that [member fill] should be when this button is not hovered
@export var normal_color := Color.WHITE
## The color that [member fill] should be when this button is hovered
@export var hover_color := Color.WHITE

## The control that handles the button fill. Used with [member normal_color] and
## [member hover_color]
@export var fill: Control
## The control that handles the underline
@export var underline: Control

var tween: Tween

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)

func _on_mouse_enter() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_parallel()
	
	if fill:
		tween.tween_property(fill, ^'self_modulate', hover_color, 0.10)
	if underline:
		tween.tween_property(underline, ^'modulate:a', 1.0, 0.10)

func _on_mouse_exit() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_parallel()
	
	if fill:
		tween.tween_property(fill, ^'self_modulate', normal_color, 0.10)
	if underline:
		tween.tween_property(underline, ^'modulate:a', 0.0, 0.10)
