extends Node

func _ready():
	await get_tree().create_timer(2).timeout
	# SaveManager.save_game()
	SaveManager.load_game()
