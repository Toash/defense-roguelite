@abstract
## abstract class for duration based status effect on pawns
## relies on lifecycle methods to run. To apply a status effect,
##      add it to the scene tree and set the pawn variable.
class_name RuntimePawnStatusEffect
extends Node2D

signal added_status_effect(node: RuntimePawnStatusEffect)
signal removed_status_effect(node: RuntimePawnStatusEffect)

var pawn: Pawn
var status_effect_data: StatusEffectData
var container: PawnStatusEffectContainer

var duration: float = INF
var t := 0.0


## call this before adding to the scene tree
func inflict_status_effect(pawn: Pawn, data: StatusEffectData):
    self.pawn = pawn
    self.status_effect_data = data
    self.container = pawn.status_effect_container.add_status_effect(self)


## called when the status effect begins.
func _on_enter(pawn: Pawn):
    added_status_effect.emit(self)

func _ready():
    _on_enter(pawn)

func _process(delta):
    if duration == INF: return
    t += delta
    if t >= duration:
        _on_exit(pawn)

## called when the status effect duration ends.
func _on_exit(pawn: Pawn):
    removed_status_effect.emit(self)
    queue_free()
