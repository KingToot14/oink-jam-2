class_name GameplayUi
extends CanvasLayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	await get_tree().process_frame
	
	# timer updates
	%'game_timer'.timer_updated.connect(_on_timer_updated)
	
	# currency updates
	CurrencyManager.pearl_collected.connect(_on_pearl_collected)
	CurrencyManager.gold_updated.connect(_on_gold_updated)
	
	# handle death
	%'game_timer'.timer_ended.connect(%'death_oxygen'.show_panel)
	%'game_timer'.timer_ended.connect(Globals.main.set_game_state.bind(GameManager.GameState.DEATH))
	
	# reset UI
	_on_pearl_collected()
	update_gold_display()

func _on_timer_updated(sec: int) -> void:
	%'sec_label'.text = "[color=#2f69a3]%s[/color][color=#255994]s[/color]" % sec

func _on_pearl_collected() -> void:
	%'white_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.WHITE]
	%'pink_label'.text  = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.PINK]
	%'black_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.BLACK]

func _on_gold_updated() -> void:
	%'gold_label'.text = "%s" % CurrencyManager.curr_gold

## Updated the gold display when currency is added/the game is loaded
func update_gold_display() -> void:
	%'gold_label'.text = "%s" % CurrencyManager.curr_gold
