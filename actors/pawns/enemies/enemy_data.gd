extends Resource

## contains the data for enemies as well as the scene for the enemy.
class_name EnemyData


@export var id: String
@export var name: String
@export var description: String


@export var scene: PackedScene


## how much it costs to spawn this type of enemy.
@export_group("Stats")
@export var health: int = 100
@export var move_speed: float = 100
@export var attack_damage: int = 25
@export var attack_speed: float = 1
@export_group("Functionality")
## item that the enemy uses
# @export var item_data: ItemData = preload("res://item/items/enemy/basic_enemy_attack.tres")
@export var item_data: ItemData = preload("uid://6rsgvhonqx4b")

@export_group("Spawning")
@export var cost: int = 1
@export var amount_spawned: int = 1

@export_group("Drops")
@export var coins_dropped: int = 100

@export_group("Vision")
@export var factions_to_track: Array[Faction.Type] = [Faction.Type.HUMAN]

## what defense priority level this enemy targets.
@export var defense_priority_targeting: RuntimeDefense.PRIORITY = RuntimeDefense.PRIORITY.VISIBLE
@export var player_vision_distance: float = 500
@export var defense_vision_distance: float = 500
@export var attack_vision_distance: float = 100


static func get_default() -> EnemyData:
	# var default_enemy_data = EnemyData.new()
	# default_enemy_data.coins_dropped = 1
	# default_enemy_data.cost = 1
	# default_enemy_data.health = 100
	# default_enemy_data.move_speed = 200
	# default_enemy_data.attack_damage = 10
	# default_enemy_data.attack_speed = 1
	# return default_enemy_data
	var default_resource = EnemyData.new()
	return default_resource
