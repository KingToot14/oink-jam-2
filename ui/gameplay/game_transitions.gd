class_name GameTransitions
extends ColorRect

# --- Variables --- #
## The main [Tween] responsible for tweening the transition fade
var tween: Tween

# --- Functions --- #

## Tweens the transition screen to [param intensity] over [param time] seconds
func tween_intensity(intensity: float, time := 0.20) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.tween_property(self, ^'color:a', intensity, time)
