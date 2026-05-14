extends Node

# --- Signals --- #
## Emits when a pearl is collected
signal pearl_collected()

## Emits when the current gold count is updated
signal gold_updated()

# --- Variables --- #
## The current number of each pearl type the player has collected
var pearl_counts: Dictionary[Pearl.PearlVariant, int] = {}

## The current amount of gold that the player has
var curr_gold: int

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
	
	# trigger updates
	pearl_collected.emit()

## Add a pearl of type [param variant] to the [member pearl_counts]
func collect_pearl(variant: Pearl.PearlVariant) -> void:
	pearl_counts[variant] += 1
	
	# clamp to 99 stacks
	pearl_counts[variant] = mini(pearl_counts[variant], 99)
	
	pearl_collected.emit()

## Adds gold to the current count
func add_gold(amount: int) -> void:
	curr_gold += amount
	
	gold_updated.emit()

## Removes gold from the current count
func remove_gold(amount: int) -> void:
	curr_gold -= amount
	
	gold_updated.emit()

## Calculate and return the amount of gold earned from selling pearls. This also
## calls [method clear_counts], resetting the pearl counters
func sell_pearls() -> int:
	var total := 0
	
	# sell each category
	total +=  1 * pearl_counts[Pearl.PearlVariant.WHITE]
	total += 10 * pearl_counts[Pearl.PearlVariant.PINK]
	total += 25 * pearl_counts[Pearl.PearlVariant.BLACK]
	
	# apply upgrades
	total = floori(total * Upgrades.get_upgrade_value(&'pearl_polishing'))
	
	# update counts
	add_gold(total)
	clear_counts()
	
	return total
