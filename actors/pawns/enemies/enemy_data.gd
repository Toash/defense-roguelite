extends Resource

class_name EnemyData

@export var scene: PackedScene


## how much it costs to spawn this type of enemy.
@export var cost: int = 1
@export var coins_dropped: int = 100

@export var amount_spawned: int = 1

@export var health: int = 100
@export var move_speed: float = 500

@export var attack_damage: int = 25
@export var attack_speed: float = 1


@export_group("Vision")
@export var defense_targeting: RuntimeDefense.PRIORITY = RuntimeDefense.PRIORITY.VISIBLE

@export var factions_to_track: Array[Pawn.FACTION] = [Pawn.FACTION.HUMAN]
@export var defense_priority_targeting: RuntimeDefense.PRIORITY = RuntimeDefense.PRIORITY.VISIBLE

## range to detect player 
@export var player_vision_distance: float = 500
## range to detect defenses
@export var defense_vision_distance: float = 500
## range to start attacking
@export var attack_vision_distance: float = 100
