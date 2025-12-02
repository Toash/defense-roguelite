extends Node

signal player_loaded

var debug_state_machines = true

var player_has_loaded = false

func _ready():
	# await get_tree().create_timer(4).timeout
	# SaveManager.save_game()
	# await get_tree().create_timer(2).timeout
	# SaveManager.load_game()
	pass


func player_load():
	player_loaded.emit()
	player_has_loaded = true