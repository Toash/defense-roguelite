extends Control

class_name GameStateUI

@export var label: Label

var game_state: GameState

func _process(delta):
	label.text = game_state.state_machine.current_state.name
