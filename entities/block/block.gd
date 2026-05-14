class_name Block
extends StaticBody2D

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	$'hp'.died.connect(_on_died)

func _on_died() -> void:
	# disable collision
	$'shape'.disabled = true
	
	# play sfx
	$'sfx'.play_sfx(&'explosion')
	$'sfx'.play_sfx(&'bubble')
	
	# play animation
	$'animator'.play(&'break')
