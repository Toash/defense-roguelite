extends ItemContainer
class_name InventoryContainer


# used to persist item positions in an inventory.
var _slot_to_inst: Dictionary[int, ItemInstance] = {}
	

func get_item(i: int) -> ItemInstance:
	return _slot_to_inst.get(i, null)

func set_item(i: int, inst: ItemInstance) -> void:
	_slot_to_inst[i] = inst

func remove(i: int) -> void:
	set_item(i, null)
