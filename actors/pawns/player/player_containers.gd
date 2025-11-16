extends Node2D


## interface for all of the players containers
class_name PlayerContainers


@export var hotbar_container: ItemContainer
@export var inventory_container: ItemContainer


## Takes amount of item_data from the player containres, if the amount of said items isnt present, returns null. 
func must_take_amount(item_data: ItemData, amount: int) -> ItemDataGroup:
    var total_group: ItemDataGroup = null
    var to_take: int = amount

    total_group = _take_as_much(hotbar_container, item_data, to_take)
    to_take -= total_group.amount
    total_group = ItemDataGroup.combine(total_group, _take_as_much(inventory_container, item_data, to_take))

    if total_group.amount == amount:
        return total_group
    else:
        return null

## drops items on the floor that dont fit.
func force_add_item_group(group: ItemDataGroup):
    var items_added: int = 0
    items_added = hotbar_container.try_add_item_group(group)
    group.amount -= items_added
    items_added = inventory_container.try_add_item_group(group)
    group.amount -= items_added


    var items_left = group.amount
    if items_left > 0:
        GroundItems.spawn_by_data(group.item_data, items_left, global_position)


## attempts to must_take_amount an amount of an item from the container.
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