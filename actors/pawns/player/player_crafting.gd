extends Node2D


class_name PlayerCrafting


@export var blueprints: Array[Blueprint]
@export var player_containers: PlayerContainers


func get_blueprints() -> Array[Blueprint]:
	return blueprints


# take ingredients from inventory, give thre player the result.
func craft(blueprint: Blueprint):
	# take items
	for ingredient: ItemDataGroup in blueprint.get_ingredients():
		if player_containers.must_take_amount(ingredient.item_data, ingredient.amount) != null:
			# took the ingredients because the player has them.
			for results: ItemDataGroup in blueprint.get_outputs():
				# add the results
				player_containers.force_add_item_group(results)
		else:
			print("Player Crafting: player does not have the necessary ingredients.")
	pass
