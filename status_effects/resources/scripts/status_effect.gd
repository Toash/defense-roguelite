extends Resource

## data container for status effects
## handles spawning status effect, as well as setting up its data.
class_name StatusEffect


@export var status_effect_scene: PackedScene
@export var status_effect_data: StatusEffectData


func apply_status_effect_to_pawn(pawn: Pawn):
	print("applying status effect")
	# TODO: Check for other status effects for synergies.
	var status_effect: RuntimePawnStatusEffect = status_effect_scene.instantiate() as RuntimePawnStatusEffect
	if status_effect == null:
		push_error("Pawn status effect scene is not the correct type!")
		return


	status_effect.inflict_status_effect(pawn, status_effect_data)
