class_name GoldStacks
extends Area2D

# --- Variables --- #
## THe victory info
@export var victory_info: Collect

## Whether or not the gold stacks have been collected this run
var collected := false

# --- Functions --- #
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&'player'):
		return
	
	# don't collect twice
	if collected:
		return
	
	collected = true
	
	Globals.collect_panel.load_collect_info(victory_info)
