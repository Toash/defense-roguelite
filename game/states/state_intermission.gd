# Intermission state
extends State


class_name IntermissionState

@export var spawn_manager: SpawnManager

@export var spawn_nodes_to_generate: int = 1
@export var intermission_time: float = 5

var intermission_timer: float = 0
var active = false

func state_enter():
	active = true
	intermission_timer = 0
	await spawn_manager.generate_spawn_nodes(spawn_nodes_to_generate)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			transitioned.emit(self, "wave")

func state_update(delta: float):
	pass
	# intermission_timer += delta
	# if intermission_timer > intermission_time:
	# 	transitioned.emit(self, "wave")

func state_physics_update(delta: float):
	pass

func state_exit():
	active = true
	pass
