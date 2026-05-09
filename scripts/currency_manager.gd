extends Node

# --- Variables --- #
## The current number of each pearl type the player has collected
var pearl_counts: Dictionary[Pearl.PearlVariant, int] = {}

# --- Functions --- #
func _ready() -> void:
	clear_counts()

## Resets the [member pearl_counts]. Typically called once the pearls have been sold
func clear_counts() -> void:
	pearl_counts = {
		Pearl.PearlVariant.WHITE: 0,
		Pearl.PearlVariant.PINK:  0,
		Pearl.PearlVariant.BLACK: 0,
	}

## Add a pearl of type [param variant] to the [member pearl_counts]
func collect_pearl(variant: Pearl.PearlVariant) -> void:
	pearl_counts[variant] += 1
	
	print(pearl_counts)
