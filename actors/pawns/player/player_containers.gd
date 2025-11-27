extends Node2D


## interface for all of the players containers
class_name PlayerContainers


@export var hotbar_container: ItemContainer
@export var inventory_container: ItemContainer

func has_enough_items(item_data: ItemData, amount: int) -> bool:
	var available := 0

	for container in [hotbar_container, inventory_container]:
		for i in container.get_capacity():
			var inst: ItemInstance = container.get_item_instance(i)
			if inst != null and inst.data == item_data:
				available += inst.quantity
				if available >= amount:
					return true

	return false

## Take amount of items across the player containers, if they are not avaliable, return null.
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
	if to_take != 0:
		push_error("PlayerContainers: WTF")
		return null
	return total_group


## drops items on the floor that dont fit.
func force_add_item_group(group: ItemDataGroup):

	var group_copy = group.duplicate()

	var items_left: int = 0
	items_left = hotbar_container.try_add_item_group(group_copy)
	group_copy.amount = items_left

	if items_left > 0:
		items_left = inventory_container.try_add_item_group(group_copy)
		group_copy.amount = items_left

	if items_left > 0:
		GroundItems.spawn_by_data(group_copy.item_data, items_left, global_position)


## take as much as avaliable from the container.
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
