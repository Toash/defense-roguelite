extends Node2D


## Handles budgeting and spawning enemies for a given world.
class_name WaveSpawner


@export var world_enemies: WorldEnemies
@export var enemy_root: Node2D

var spawn_budget: float = 0
var spawn_budget_increase_multiplier: float = 1
@onready var rng = RandomNumberGenerator.new()


func _process(delta):
	spawn_budget += delta * spawn_budget_increase_multiplier


func spawn(global_pos: Vector2):
	var enemy_data: EnemyData = world_enemies.get_random_enemy_data(0, spawn_budget)
	if enemy_data == null: return
	
	for i in enemy_data.amount_spawned:
		var enemy: Enemy = enemy_data.scene.instantiate() as Enemy

		var offset: Vector2 = Vector2.ZERO
		if enemy_data.amount_spawned > 1:
			offset = Vector2(rng.randf_range(-100, 100), rng.randf_range(-100, 100))
		enemy.global_position = global_pos + offset

		if enemy == null:
			push_error("Wave: spawned pawn is not of type enemy!")

		enemy.setup(enemy_data)
		enemy_root.add_child.call_deferred(enemy)

	spawn_budget -= enemy_data.cost
