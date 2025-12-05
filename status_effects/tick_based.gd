@abstract
## used for effects that need to do stuff on the pawn every tick
class_name TickBased
extends RuntimePawnStatusEffect


var status_effect_timer: float = 0

const TICK_DELAY = 1


func _process(delta):
	super._process(delta)
	status_effect_timer += delta

	if status_effect_timer >= TICK_DELAY:
		_on_tick(pawn)
		status_effect_timer = 0

@abstract
func _on_tick(pawn: Pawn)