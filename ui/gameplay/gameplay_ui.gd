class_name GameplayUi
extends CanvasLayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	await get_tree().process_frame
	
	# timer updates
	%'game_timer'.timer_updated.connect(_on_timer_updated)
	%'player'.hp_modified.connect(_on_hp_modified)
	
	# currency updates
	CurrencyManager.pearl_collected.connect(_on_pearl_collected)
	CurrencyManager.gold_updated.connect(_on_gold_updated)
	
	# handle death
	%'game_timer'.timer_ended.connect(%'death_oxygen'.show_panel)
	%'game_timer'.timer_ended.connect(Globals.main.set_game_state.bind(GameManager.GameState.DEATH))
	
	%'player'.died.connect(%'death_health'.show_panel)
	%'player'.died.connect(Globals.main.set_game_state.bind(GameManager.GameState.DEATH))
	
	# reset UI
	_on_pearl_collected()
	_on_hp_modified()
	update_gold_display()

func _on_timer_updated(sec: int) -> void:
	%'sec_label'.text = "%s[color=#255994]s[/color]" % sec

func _on_hp_modified() -> void:
	%'hp_label'.text = "%s [color=#91272b]HP[/color]" % %'player'.curr_hp

func _on_pearl_collected() -> void:
	%'white_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.WHITE]
	%'pink_label'.text  = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.PINK]
	%'black_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.BLACK]

func _on_gold_updated() -> void:
	%'gold_label'.text = "%s" % CurrencyManager.curr_gold

## Updated the gold display when currency is added/the game is loaded
func update_gold_display() -> void:
	%'gold_label'.text = "%s" % CurrencyManager.curr_gold
