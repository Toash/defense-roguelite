extends Resource

class_name PawnStatusEffectResource


@export var status_effect_scene: PackedScene
@export var status_effect_data: StatusEffectData


func add_status_effect(pawn: Pawn):
    var status_effect: RuntimePawnStatusEffect = status_effect_scene.instantiate() as RuntimePawnStatusEffect
    if status_effect == null:
        push_error("Pawn status effect scene is not the correct type!")
        return


    status_effect.inflict_status_effect(pawn, status_effect_data)
    pass