extends ItemInstanceProvider


## Represents current instance that is equipped in the hotbar.
class_name HotbarEquippedInst

signal holding_something
signal holding_nothing

@export var hotbar_container: ItemContainer
@export var hotbar_input: HotbarInput
var equipped_index: int


func _ready():
	hotbar_input.equip_slot.connect(_on_equip_slot)


func _on_equip_slot(index: int):
	# if ItemService.player_containers[ItemService.ContainerName.HOTBAR].get_capacity() <= index:
	if hotbar_container.get_capacity() <= index:
		push_error("Hotbar does not have the right capacity to equip index " + str(index))
		return

	# var inst: ItemInstance = ItemService.containers[ItemService.ContainerName.HOTBAR].get_item(index)
	set_equipped_index(index)

func get_inst() -> ItemInstance:
	var inst = hotbar_container.get_item(equipped_index)
	return inst

func set_equipped_index(index: int):
	equipped_index = index
	instance_changed.emit(get_inst())

	if get_inst() != null:
		holding_something.emit()
	else:
		holding_nothing.emit()