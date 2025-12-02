extends Node2D


class_name PlayerCrafting


@export var coins: PlayerCoins
@export var blueprints: Array[Blueprint]
@export var player_containers: PlayerContainers


func add_blueprint(blueprint: Blueprint):
	blueprints.append(blueprint)


func get_blueprints() -> Array[Blueprint]:
	return blueprints

func get_defense_types() -> Array[DefenseData.DEFENSE_TYPE]:
	var ret: Array[DefenseData.DEFENSE_TYPE] = []
	for blueprint in blueprints:
		var defense_types: Array[DefenseData.DEFENSE_TYPE] = blueprint.get_defense_type_outputs()
		ret += defense_types
		
	return ret


func craft(blueprint: Blueprint):
	var blueprint_copy = blueprint.duplicate()
	if not coins.has_enough(blueprint_copy.coins_needed):
		TextPopupManager.popup("Not enough coins!", get_viewport_rect().size / 2)
		return
		
	for ingredient: ItemDataGroup in blueprint_copy.get_ingredients():
		if not player_containers.has_enough_items(ingredient.item_data, ingredient.amount):
			TextPopupManager.popup("Not enough items!", get_viewport_rect().size / 2)
			return

	for ingredient: ItemDataGroup in blueprint_copy.get_ingredients():
		player_containers.must_take_amount(ingredient.item_data, ingredient.amount)

	for results: ItemDataGroup in blueprint_copy.get_outputs():
		player_containers.force_add_item_group(results)
	coins.change_coins(-blueprint_copy.coins_needed)
