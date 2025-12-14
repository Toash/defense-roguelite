extends Resource
## data container for melee scene.
class_name MeleeData

## the scene to instantiate when using the melee.
@export var melee_scene: PackedScene


@export var damage: int = 25
@export var pierce: int = 1
@export var status_effects: Array[StatusEffect]