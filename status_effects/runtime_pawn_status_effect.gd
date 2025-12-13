@abstract
class_name RuntimePawnStatusEffect
extends Node2D

signal runtime_status_effect_started(node: RuntimePawnStatusEffect)
signal runtime_status_effect_ended_before_queue_free(node: RuntimePawnStatusEffect)


var pawn: Pawn
var data: StatusEffectData

var t := 0.0


## called when the status type begins.
func _on_enter(pawn: Pawn):
	runtime_status_effect_started.emit(self)

func _ready():
	_on_enter(pawn)

func _process(delta):
	t += delta
	if t >= data.duration:
		_on_exit(pawn)

## called when the status type duration ends.
func _on_exit(pawn: Pawn):
	runtime_status_effect_ended_before_queue_free.emit(self)
	queue_free()
