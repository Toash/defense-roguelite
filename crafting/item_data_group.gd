extends Resource


## abstract representation of a group of items.
class_name ItemDataGroup


@export var item_data: ItemData
@export var amount: int

static func create(item_data: ItemData, amount: int) -> ItemDataGroup:
    var item_data_group: ItemDataGroup = ItemDataGroup.new()

    item_data_group.item_data = item_data
    item_data_group.amonut = amount
    return item_data_group


static func combine(group_1: ItemDataGroup, group_2: ItemDataGroup) -> ItemDataGroup:
    if group_1.item_data != group_2.item_data: return null

    var total_amount: int = group_1.amount + group_2.amount
    var item_data_group = ItemDataGroup.new()

    item_data_group.item_data = group_1.data
    item_data_group.amount = total_amount

    return item_data_group

static func create_from_inst(inst: ItemInstance) -> ItemDataGroup:
    var item_data_group = ItemDataGroup.new()

    item_data_group.item_data = inst.data
    item_data_group.amount = inst.quantity

    return item_data_group


func get_amount() -> int:
    return amount

func get_item_data() -> ItemData:
    return item_data