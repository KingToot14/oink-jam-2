@tool
class_name UpgradeBox
extends SimpleButton

# --- Variables --- #
## The upgrade to display in this box
@export var upgrade: Upgrade:
	set(_val):
		upgrade = _val
		update_info()

## The tween responsible for flashing
var flash_tween: Tween

# --- Functions --- #
func _ready() -> void:
	super()
	
	update_info()

func _on_mouse_enter() -> void:
	super()
	
	# update info text
	Globals.upgrade_menu.select_upgrade(upgrade)

func _on_mouse_exit() -> void:
	super()
	
	# clear info text
	Globals.upgrade_menu.deselect_upgrade(upgrade)

## Updates the upgrade info
func update_info() -> void:
	if not upgrade or Engine.is_editor_hint():
		return
	
	# check if upgrade is locked
	if not upgrade.unlocked:
		$'locked_field'.show()
	else:
		$'locked_field'.hide()
	
	# update info
	$'title'.text = upgrade.name
	$'image'.texture = upgrade.icon
	
	$'level'.text = "Lvl %s" % upgrade.level
	
	if upgrade.level >= upgrade.max_level:
		$'cost'.text = "Max Level!"
	else:
		$'cost'.text = "%s" % upgrade.get_cost()

## Attempt to level up this upgrade
func try_upgrade() -> void:
	if not upgrade:
		return
	
	# try upgrade
	if not upgrade.try_upgrade_level():
		return
	
	# play sfx
	$'sfx'.play_sfx(&'upgrade')
	
	# do flash animation
	do_flash()
	
	update_info()

## Flash the upgrade box when levelling up
func do_flash() -> void:
	$'flash'.modulate.a = 1.0
	
	if flash_tween:
		flash_tween.kill()
	
	flash_tween = create_tween()
	flash_tween.tween_property($'flash', ^'modulate:a', 0.0, 0.25)
