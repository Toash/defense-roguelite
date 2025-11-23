# Intermission state
extends State

@export var game_state: GameState

@export var intermission_time: float = 5

var t: float = 0

func state_enter():
	t = 0
	

func state_update(delta: float):
	t += delta
	if t > intermission_time:
		transitioned.emit(self, "wave")

func state_physics_update(delta: float):
	pass

func state_exit():
	pass
