class_name GameplayUi
extends CanvasLayer

# --- Variables --- #
const DASH_BAR_WIDTH := 92.0

# --- Functions --- #
func _ready() -> void:
	await get_tree().process_frame
	
	# timer updates
	%'game_timer'.timer_updated.connect(_on_timer_updated)
	%'player'.hp.hp_modified.connect(_on_hp_modified)
	
	# currency updates
	CurrencyManager.pearl_collected.connect(_on_pearl_collected)
	CurrencyManager.gold_updated.connect(_on_gold_updated)
	
	# handle death
	%'game_timer'.timer_ended.connect(%'death_oxygen'.show_panel)
	%'game_timer'.timer_ended.connect(%'player'.end_game)
	%'game_timer'.timer_ended.connect(Globals.main.set_game_state.bind(GameManager.GameState.DEATH))
	
	%'player'.hp.died.connect(%'death_health'.show_panel)
	%'player'.hp.died.connect(%'player'.end_game)
	%'player'.hp.died.connect(Globals.main.set_game_state.bind(GameManager.GameState.DEATH))
	
	# actions
	%'player'.dash_used.connect(_on_dash_used)
	%'player'.cannon_fired.connect(_on_cannon_fired)
	
	# reset UI
	_on_pearl_collected()
	_on_hp_modified()
	update_gold_display()

func _on_timer_updated(sec: int) -> void:
	%'sec_label'.text = "%s[color=#255994]s[/color]" % sec

func _on_hp_modified() -> void:
	%'hp_label'.text = "%s [color=#91272b]HP[/color]" % %'player'.hp.curr_hp

func _on_pearl_collected() -> void:
	%'white_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.WHITE]
	%'pink_label'.text  = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.PINK]
	%'black_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.BLACK]

func _on_gold_updated() -> void:
	%'gold_label'.text = "%s" % CurrencyManager.curr_gold

func _on_dash_used() -> void:
	$'oxygen_bar/bar_display/mask'.size.x = DASH_BAR_WIDTH * %'player'.get_dash_percent()

func _on_cannon_fired() -> void:
	%'ammo_label'.text = "%s" % %'player'.curr_ammo

## Updated the gold display when currency is added/the game is loaded
func update_gold_display() -> void:
	%'gold_label'.text = "%s" % CurrencyManager.curr_gold

## Resets all ui counters
func reset() -> void:
	_on_hp_modified()
	_on_pearl_collected()
	_on_gold_updated()
	_on_dash_used()
	_on_cannon_fired()
	update_gold_display()
