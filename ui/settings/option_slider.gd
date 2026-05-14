class_name OptionSlider
extends Control

# --- Variables --- #
@export var option_category: StringName

@export var default_value := 1.0

@export_group("Value", "value_")
@export var value_min := 0
@export var value_max := 100
@export var value_step := 5

@export var value_label: RichTextLabel
@export var value_suffix: String

var dragging := false

# --- Functions --- #
func _ready() -> void:
	update_value(default_value)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		dragging = event.is_pressed()
	
	if (dragging and event is InputEventMouseMotion) or (event is InputEventMouseButton and event.button_index == 1):
		var mouse_pos := clampf(roundi(event.global_position.x - 3), global_position.x, global_position.x + size.x - 6)
		var value := (mouse_pos - global_position.x) / (size.x - 6)
		
		update_value(value)

#func _on_mouse_enter() -> void:
	#$'handle'.update_theme(ThemePreset.ColorValue.WHITE)
#
#func _on_mouse_exit() -> void:
	#$'handle'.update_theme(ThemePreset.ColorValue.LIGHT)

func update_value(value: float) -> void:
	value = float(roundi((value * value_max - value_min) / value_step) * value_step + value_min) / value_max
	
	$'handle'.global_position.x = global_position.x + value * (size.x - 6)
	$'fill'.size.x = roundi($'handle'.global_position.x - global_position.x + 2)
	
	if value_label:
		value_label.text = "%d%s" % [value * 100.0, value_suffix]
	
	# set audio bus level
	var id: int
	
	match option_category:
		&'master':
			id = AudioServer.get_bus_index(&'Master')
		&'music':
			id = AudioServer.get_bus_index(&'Music')
		&'entity':
			id = AudioServer.get_bus_index(&'SFX')
		&'engine':
			id = AudioServer.get_bus_index(&'Engine')
	
	AudioServer.set_bus_volume_linear(id, value)
