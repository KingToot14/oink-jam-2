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
	
	update_info()
