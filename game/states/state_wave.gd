# Wave state
extends State

class_name WaveState


@export var game_state: GameState
@export var enemy_root: Node2D
@export var enemy_data: EnemyData

@export var wave_spawner: WaveSpawner
@export var wave_time: float = 10

var world: World
var spawn_timer: float = 0
var wave_timer: float = 0


func state_enter():
	spawn_timer = 0
	wave_timer = 0
	TextPopupManager.popup("Wave incoming...", get_viewport_rect().size / 2)
	pass
	

func state_update(delta: float):
	spawn_timer += delta
	wave_timer += delta

	if spawn_timer > 2:
		wave_spawner.spawn(game_state._get_random_spawn_point())
		spawn_timer = 0


	if wave_timer > wave_time:
		transitioned.emit(self, "intermission")

func state_physics_update(delta: float):
	pass

func state_exit():
	pass
