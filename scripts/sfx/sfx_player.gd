class_name SfxPlayer
extends AudioStreamPlayer2D

# --- Variables --- #
## Holds a library of sound effects referencable by key. These are primarily used in
## the [method play_sfx] method
@export var sfx_library: Dictionary[StringName, SoundEffect] = {}

## References to all the [AudioStreamPlayer2D]s that handle the sound effects
var sfx_players: Dictionary[StringName, AudioStreamPlayer2D] = {}

# --- Functions --- #
func _ready() -> void:
	# create a sfx player for each loaded sound
	for sfx: StringName in sfx_library.keys():
		# create a new player
		var player := AudioStreamPlayer2D.new()
		player.max_polyphony = 8
		
		player.attenuation = attenuation
		player.max_distance = max_distance
		player.bus = bus
		
		# load the sfx
		player.volume_db = sfx_library[sfx].volume
		player.pitch_scale = sfx_library[sfx].pitch_scale
		player.stream = sfx_library[sfx].stream
		
		# add the player as a child
		add_child(player)
		sfx_players[sfx] = player

## Plays a sound effect identified by [param sfx_key]. Uses a single [AudioStreamPlayer2D]
## with polyphony
func play_sfx(sfx_key: StringName) -> void:
	sfx_players[sfx_key].play()
