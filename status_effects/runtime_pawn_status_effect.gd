@abstract
class_name RuntimePawnStatusEffect
extends Node2D

signal added_status_effect(node: RuntimePawnStatusEffect)
signal removed_status_effect(node: RuntimePawnStatusEffect)


enum TYPE {
	FIRE,
}


var pawn: Pawn
var data: StatusEffectData

var t := 0.0

func inflict_status_effect_on_pawn(pawn: Pawn, data: StatusEffectData):
	self.pawn = pawn
	self.data = data
	pawn.status_effect_container.add_status_effect(self)


## called when the status type begins.
func _on_enter(pawn: Pawn):
	added_status_effect.emit(self)

func _ready():
	_on_enter(pawn)

func _process(delta):
	t += delta
	if t >= data.duration:
		_on_exit(pawn)

## called when the status type duration ends.
func _on_exit(pawn: Pawn):
	# removed_status_effect.emit(self)
	removed_status_effect.emit()
	queue_free()
