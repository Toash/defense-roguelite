extends Pawn


class_name Enemy

## used when none is supplied by a spawner.
var enemy_data: EnemyData

@export var state_machine: StateMachine
@export var tile_pathfind: TilePathfind

func _ready():
	add_to_group("enemy")
	health.died.connect(_on_death)

func setup(data: EnemyData):
	enemy_data = data
	self.health.set_max_health(int(data.health))
	self.health.set_health(data.health)

func get_data() -> EnemyData:
	if enemy_data == null:
		var default_enemy_data = EnemyData.new()

		default_enemy_data.cost = 1
		default_enemy_data.health = 100
		default_enemy_data.move_speed = 500
		default_enemy_data.attack_damage = 25
		default_enemy_data.attack_speed = 1

		return default_enemy_data
	else:
		return enemy_data
		

func _on_death():
	remove_from_group("enemy")

	state_machine.queue_free()
	tile_pathfind.queue_free()

	set_collision_layer_value(3, false)
	await get_tree().create_timer(5).timeout
	queue_free.call_deferred()