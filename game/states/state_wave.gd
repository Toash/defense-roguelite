# Wave state
extends State

@export var game_state: GameState
@export var enemy_root: Node2D
@export var enemy_data: EnemyData

var world: World
var t: float = 0


func state_enter():
	pass
	

func state_update(delta: float):
	t += delta

	if t > 2:
		_spawn(enemy_data, game_state._get_random_spawn_point())
		t = 0

func state_physics_update(delta: float):
	pass

func state_exit():
	pass

func _spawn(enemy_data: EnemyData, global_pos: Vector2):
	var enemy: Enemy = enemy_data.scene.instantiate() as Enemy
	enemy.global_position = global_pos
	if enemy == null:
		push_error("Wave: spawned pawn is not of type enemy!")
	enemy.setup(enemy_data)
	enemy_root.add_child.call_deferred(enemy)
