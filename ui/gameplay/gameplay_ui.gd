class_name GameplayUi
extends CanvasLayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	await get_tree().process_frame
	
	%'game_timer'.timer_updated.connect(_on_timer_updated)
	CurrencyManager.pearl_collected.connect(_on_pearl_collected)
	
	# handle death
	%'game_timer'.timer_ended.connect(%'death_oxygen'.show_panel)
	%'game_timer'.timer_ended.connect(Globals.main.set_game_state.bind(GameManager.GameState.DEATH))
	
	# reset UI
	_on_pearl_collected()

func _on_timer_updated(sec: int) -> void:
	%'sec_label'.text = "[color=#2f69a3]%s[/color][color=#255994]s[/color]" % sec

func _on_pearl_collected() -> void:
	%'white_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.WHITE]
	%'pink_label'.text  = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.PINK]
	%'black_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.BLACK]
