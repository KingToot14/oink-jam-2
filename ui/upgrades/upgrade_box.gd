@tool
class_name UpgradeBox
extends SimpleButton

# --- Variables --- #
@export var upgrade: Upgrade:
	set(_val):
		upgrade = _val
		update_info()

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
		$'cost'.hide()
	else:
		$'cost'.text = "%s" % upgrade.get_cost()

func try_upgrade() -> void:
	if not upgrade:
		return
	
	# try upgrade
	if not upgrade.try_upgrade_level():
		return
	
	# play sfx
	$'sfx'.play_sfx(&'upgrade')
	
	update_info()
