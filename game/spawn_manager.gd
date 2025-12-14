extends Node2D


## Handles budgeting and spawning enemies for a given world.
class_name SpawnManager


@export var world: World


## root node to spawn enemies on.
@export var enemy_root: Node2D

var spawn_budget: float = 0
var spawn_budget_increase_multiplier: float = 1
var rng = RandomNumberGenerator.new()

var spawn_nodes: Array[Node2D]

var spawning = true


func _process(delta):
	spawn_budget += delta * spawn_budget_increase_multiplier


func spawn_at_random_spawn_node():
	if not spawning: return
	var enemy_data: EnemyData = world.world_config.enemies.get_random_world_enemy_data_by_random_cost(0, spawn_budget)
	if enemy_data == null: return
	
	for i in enemy_data.amount_spawned:
		var enemy: RuntimeEnemy = enemy_data.scene.instantiate() as RuntimeEnemy

		var offset: Vector2 = Vector2.ZERO
		if enemy_data.amount_spawned > 1:
			offset = Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))
		# enemy.global_position = global_pos + offset
		enemy.global_position = _get_random_spawn_node() + offset

		if enemy == null:
			push_error("Wave: spawned pawn is not of type enemy!")

		enemy.setup(enemy_data)
		enemy_root.add_child.call_deferred(enemy)

	spawn_budget -= enemy_data.cost

func generate_spawn_nodes(amount: int = 1):
	spawn_nodes = await world.get_spawn_nodes(amount)


func _get_random_spawn_node() -> Vector2:
	if spawn_nodes.size() > 0:
		return spawn_nodes[randi() % spawn_nodes.size()].global_position
	push_error("Game state does not have any spawn_at_random_spawn_node nodes!")
	return Vector2.ZERO
