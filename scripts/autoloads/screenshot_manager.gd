extends Node

# --- Variables --- #


# --- Functions --- #
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed(&'screenshot'):
		return
	
	var capture = get_viewport().get_texture().get_image()
	
	var date = Time.get_datetime_dict_from_system()
	
	if not DirAccess.dir_exists_absolute('user://screenshots'):
		DirAccess.make_dir_absolute('user://screenshots')
	
	var path = "user://screenshots/%02d-%02d-%02d-%02d_%02d.png"
	path = path % [date['month'], date['day'], date['year'], date['minute'], date['second']]
	
	capture.save_png(path)
