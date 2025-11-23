extends Control

class_name GameStateUI

@export var label: Label

var game_state: GameState

func _process(delta):
	# label.text = "awdfuoadsfia"
	# label.text = game_state.state_machine.current_state.name
	# label.text = str(game_state)
	label.text = game_state.get_debug_string()
