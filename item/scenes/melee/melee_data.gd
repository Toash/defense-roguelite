extends Resource
## used to transfer data from melee effect to melee scene.
class_name MeleeData

@export var melee_scene: PackedScene
@export var factions_to_hit: Array[Pawn.FACTION]
@export var damage: int = 25
@export var pierce: int = 1
@export var status_effects: Array[StatusEffect]