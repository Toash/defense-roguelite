extends Node2D


class_name GameState


enum PHASE {

	NONE,
	INTERMISSION,
	WAVE,
}


@export var state_machine: StateMachine
@export var intermission_state: IntermissionState
@export var wave_state: WaveState
@export var spawn_manager: SpawnManager


var spawn_nodes : Array[Node2D]



func get_phase() -> PHASE:
	match state_machine.current_state:
		"intermission":
			return PHASE.INTERMISSION
		"wave":
			return PHASE.WAVE
	return PHASE.NONE



func get_debug_string() -> String:
	# return "asdf"
	var s: String = "State: " + state_machine.current_state.name + "\n"

	s += "Spawn Budget: " + str("%.1f" % spawn_manager.spawn_budget) + "\n"

	match state_machine.current_state.name.to_lower():
		"intermission":
			s += "Intermission time : " + str(intermission_state.intermission_time) + "\n"
			s += "Intermission timer : " + str(int(intermission_state.intermission_timer)) + "\n"
		"wave":
			s += "Wave time : " + str(wave_state.wave_time) + "\n"
			s += "Wave timer : " + str(int(wave_state.wave_timer)) + "\n"
		_:
			s += "what"
	return s
