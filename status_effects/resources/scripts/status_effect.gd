extends Resource

## data container for status effects
## handles spawning status effect, as well as setting up its data.
class_name StatusEffect


## the status effect scene to spawn onto whatever is being effected.
@export var packed_scene: PackedScene
@export var data: StatusEffectData


func apply_status_effect_to_pawn(pawn: Pawn):
	var status_effect: RuntimePawnStatusEffect = packed_scene.instantiate() as RuntimePawnStatusEffect
	if status_effect == null:
		push_error("Pawn status effect packed_scene is not the correct type!")
		return


	status_effect.inflict_status_effect_on_pawn(pawn, data)
