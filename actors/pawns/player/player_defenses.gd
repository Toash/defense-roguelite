extends Node2D


## node for player owned defenses
class_name PlayerDefenses


@export var player_crafting: PlayerCrafting


# func _ready():
# 	await get_tree().create_timer(1).timeout
# 	get_player_owned_defense_types()

func get_player_owned_defense_types() -> Array[DefenseData.DEFENSE_TYPE]:
	var ret: Array[DefenseData.DEFENSE_TYPE] = []
	for blueprint in player_crafting.get_blueprints():
		var defense_types: Array[DefenseData.DEFENSE_TYPE] = blueprint.get_defense_type_outputs()
		ret += defense_types
	print(ret)
	return ret
