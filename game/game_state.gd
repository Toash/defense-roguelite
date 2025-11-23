extends Node2D


class_name GameState


enum PHASE {

	NONE,
	INTERMISSION,
	WAVE,
}


@export var world: World
@export var state_machine: StateMachine


# TODO: get spawn_points from world
@export var spawn_points: Array[Node2D]


func get_phase() -> PHASE:
	match state_machine.current_state:
		"intermission":
			return PHASE.INTERMISSION
		"wave":
			return PHASE.WAVE
	return PHASE.NONE


func _get_random_spawn_point() -> Vector2:
	if spawn_points.size() <= 0:
		push_error("Spawner does not have spawn points!")
		return Vector2.ZERO

	var spawn_point: Vector2 = spawn_points[randi() % spawn_points.size()].global_position
	return spawn_point