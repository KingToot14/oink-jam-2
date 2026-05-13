class_name Block
extends StaticBody2D

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	$'hp'.died.connect(_on_died)

func _on_died() -> void:
	$'animator'.play(&'break')
