class_name Block
extends StaticBody2D

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	$'hp'.died.connect(_on_died)

func _on_died() -> void:
	# disable collision
	$'shape'.queue_free()
	
	# play sfx
	$'sfx'.play_sfx(&'explode')
	$'sfx'.play_sfx(&'bubble')
	
	# play animation
	$'animator'.play(&'break')
