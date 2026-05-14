extends Node

# --- Variables --- #
## The root of the game
var main: GameManager

## The current instance of the player controller
var player: PlayerController

## The current timer running for the main game loop
var timer: GameTimer

## The current upgrade manager for the main game loop
var upgrade_menu: UpgradeManager

## The current collection panel for the main game loop
var collect_panel: CollectPanel

## Whether or not a pearl has been collected before
var pearl_collected := false

# --- Functions --- #
