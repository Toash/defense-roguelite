extends Node2D


## Handles budgeting and spawning enemies for a given world.
class_name WaveSpawner


@export var world_enemies: WorldEnemies
@export var enemy_root: Node2D

var spawn_budget: float = 0
var spawn_budget_increase_multiplier: float = 1


func _process(delta):
	spawn_budget += delta * spawn_budget_increase_multiplier


func spawn(global_pos: Vector2):
	var enemy_data: EnemyData = world_enemies.get_random_enemy_data(0, spawn_budget)
	if enemy_data == null: return
	
	var enemy: Enemy = enemy_data.scene.instantiate() as Enemy

	enemy.global_position = global_pos
	if enemy == null:
		push_error("Wave: spawned pawn is not of type enemy!")

	enemy.setup(enemy_data)
	enemy_root.add_child.call_deferred(enemy)

	spawn_budget -= enemy_data.cost
