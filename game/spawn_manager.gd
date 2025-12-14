extends Node2D


## Handles budgeting and spawning enemies for a given world.
class_name SpawnManager


@export var world: World


## root node to spawn enemies on.
@export var enemy_root: Node2D

var spawn_radius: float = 1000
var spawn_budget: float = 0
var spawn_budget_increase_multiplier: float = 1
var rng = RandomNumberGenerator.new()

var spawn_nodes: Array[Node2D]
var spawn_delay: float = 1

var spawning = true


func _process(delta):
	spawn_budget += delta * spawn_budget_increase_multiplier
	print(spawn_radius)


func spawn_at_random_spawn_node():
	if not spawning: return
	var enemy_data: EnemyData = get_by_cost(0, spawn_budget)
	if enemy_data == null:
		print("Did not find a suitable enemy to spawn.")
		return
	
	for i in enemy_data.amount_spawned:
		var runtime_enemy: RuntimeEnemy = enemy_data.scene.instantiate() as RuntimeEnemy

		var offset: Vector2 = Vector2.ZERO
		if enemy_data.amount_spawned > 1:
			offset = Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))
		runtime_enemy.global_position = _get_random_spawn_node() + offset

		if runtime_enemy == null:
			push_error("Wave: spawned pawn is not of type runtime_enemy!")

		runtime_enemy.setup(enemy_data)
		enemy_root.add_child.call_deferred(runtime_enemy)

	spawn_budget -= enemy_data.cost

func generate_spawn_nodes(amount: int = 1):
	spawn_nodes = await world.get_spawn_nodes(amount, spawn_radius)


func _get_random_spawn_node() -> Vector2:
	if spawn_nodes.size() > 0:
		return spawn_nodes[randi() % spawn_nodes.size()].global_position
	push_error("Game state does not have any spawn_at_random_spawn_node nodes!")
	return Vector2.ZERO

# gets random enemy data between min and max cost.
func get_by_cost(min_cost: float, max_cost: float) -> EnemyData:
	var world_enemies = world.world_config.world_enemies
	var candidates: Array[EnemyData]

	for enemy_data: EnemyData in world_enemies.enemies:
		if enemy_data.cost <= max_cost and enemy_data.cost >= min_cost:
			candidates.append(enemy_data)

	if candidates.size() == 0: return null
	return candidates[randi() % candidates.size()]
