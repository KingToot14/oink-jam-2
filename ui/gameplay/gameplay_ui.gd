class_name GameplayUi
extends CanvasLayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	%'game_timer'.timer_updated.connect(_on_timer_updated)
	CurrencyManager.pearl_collected.connect(_on_pearl_collected)

func _on_timer_updated(sec: int) -> void:
	%'sec_label'.text = "[color=#2f69a3]%s[/color][color=#255994]s[/color]" % sec

func _on_pearl_collected() -> void:
	%'white_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.WHITE]
	%'pink_label'.text  = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.PINK]
	%'black_label'.text = "%s" % CurrencyManager.pearl_counts[Pearl.PearlVariant.BLACK]
