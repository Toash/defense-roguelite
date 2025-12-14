extends Node2D


## runtime node for the current game state.
class_name GameState


enum PHASE {

	NONE,
	INTERMISSION,
	WAVE,
}


@export var upgrade_manager: UpgradeManager
@export var defense_manager: DefenseManager
@export var aggro_manager: AggroManager
@export var enemy_manager: RuntimeEnemyManager

@export var state_machine: StateMachine
@export var intermission_state: IntermissionState
@export var wave_state: WaveState
@export var spawn_manager: SpawnManager


func _ready():
	add_to_group("game_state")


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
			# s += "Intermission time : " + str(intermission_state.intermission_time) + "\n"
			# s += "Intermission timer : " + str(int(intermission_state.intermission_timer)) + "\n"
			s += "Waiting for input to start next wave..."
		"wave":
			s += "Wave time : " + str(wave_state.wave_time) + "\n"
			s += "Wave timer : " + str(int(wave_state.wave_timer)) + "\n"
		_:
			s += "what"
	return s
