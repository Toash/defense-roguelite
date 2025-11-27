# Intermission state
extends State


class_name IntermissionState

@export var game_state: GameState
@export var spawn_manager: SpawnManager
@export var nexus: Nexus
@export var world: World

@export var intermission_time: float = 5

var intermission_timer: float = 0

func state_enter():
	intermission_timer = 0
	# world.get_spawn_nodes(Vector2.ZERO, 3)
	await spawn_manager.generate_spawn_nodes(1)
	

func state_update(delta: float):
	intermission_timer += delta
	if intermission_timer > intermission_time:
		transitioned.emit(self, "wave")

func state_physics_update(delta: float):
	pass

func state_exit():
	pass
