extends Node

signal player_loaded

var debug_state_machines = true 


func _ready():
	# await get_tree().create_timer(4).timeout
	# SaveManager.save_game()
	# await get_tree().create_timer(2).timeout
	# SaveManager.load_game()
	pass


func player_load():
	player_loaded.emit()