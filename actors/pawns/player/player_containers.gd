extends Node2D


## interface for all of the players containers
class_name PlayerContainers


@export var hotbar_container: ItemContainer
@export var inventory_container: ItemContainer


## Takes amount of item_data from the player containres, if the amount of said items isnt present, returns null. 
# func must_take_amount(item_data: ItemData, amount: int) -> ItemDataGroup:
# 	var total_group: ItemDataGroup = null
# 	var to_take: int = amount

# 	total_group = _take_as_much(hotbar_container, item_data, to_take)
# 	to_take -= total_group.amount
# 	if total_group != null:
# 		total_group = ItemDataGroup.combine(total_group, _take_as_much(inventory_container, item_data, to_take))
# 	else:
# 		total_group = _take_as_much(inventory_container, item_data, to_take)

# 	if total_group.amount == amount:
# 		return total_group
# 	else:
# 		return null


func must_take_amount(item_data: ItemData, amount: int) -> ItemDataGroup:
	var available := 0

	# 1) Count how many we have across both containers
	for container in [hotbar_container, inventory_container]:
		for i in container.get_capacity():
			var inst: ItemInstance = container.get_item_instance(i)
			if inst != null and inst.data == item_data:
				available += inst.quantity

	if available < amount:
		return null # not enough, do nothing

	# 2) We know we have enough → actually take
	var total_group: ItemDataGroup = null
	var to_take := amount

	var group_hotbar := _take_as_much(hotbar_container, item_data, to_take)
	if group_hotbar != null:
		total_group = group_hotbar
		to_take -= group_hotbar.amount

	if to_take > 0:
		var group_inventory := _take_as_much(inventory_container, item_data, to_take)
		if group_inventory != null:
			if total_group == null:
				total_group = group_inventory
			else:
				total_group = ItemDataGroup.combine(total_group, group_inventory)
			to_take -= group_inventory.amount

	# at this point, to_take should be 0 if everything is correct
	return total_group


## drops items on the floor that dont fit.
func force_add_item_group(group: ItemDataGroup):
	var items_left: int = 0
	items_left = hotbar_container.try_add_item_group(group)
	group.amount = items_left

	if items_left > 0:
		items_left = inventory_container.try_add_item_group(group)
		group.amount = items_left

	if items_left > 0:
		GroundItems.spawn_by_data(group.item_data, items_left, global_position)


## attempts to take an amount of an item from the container.
## amount left is the amount_to_take - the amount in the returned group.
func _take_as_much(container: ItemContainer, item_data: ItemData, amount_to_take: int) -> ItemDataGroup:
	var total_group: ItemDataGroup = null
	var amount_needed_to_take = amount_to_take

	for i in container.get_capacity():
		var inst = container.get_item_instance(i)
		if inst != null:
			if inst.data == item_data:
				var taken_group: ItemDataGroup = container.take_as_much(i, amount_needed_to_take)
				amount_needed_to_take -= taken_group.amount

				if total_group == null:
					total_group = taken_group
				else:
					total_group = ItemDataGroup.combine(total_group, taken_group)

				if amount_needed_to_take == 0: break
			
	return total_group
