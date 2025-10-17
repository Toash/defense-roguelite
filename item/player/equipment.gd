extends Node

class_name Equipment
signal equipment_changed(inst: ItemInstance)
## indexes into hotbar to use the iteminstance.

@export var hotbar_input: HotbarInput
# var equipped_instance: ItemInstance
var equipped_index: int


func _ready() -> void:
	hotbar_input.equip_slot.connect(_on_equip_slot)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_equipment"):
		use()

func _on_equip_slot(index: int):
	if ItemService.containers[ItemService.ContainerName.HOTBAR].get_capacity() <= index:
		push_error("Hotbar does not have the right capacity to equip index " + str(index))
		return

	# var inst: ItemInstance = ItemService.containers[ItemService.ContainerName.HOTBAR].get_item(index)
	set_equipped_index(index)

func get_equipped_item() -> ItemInstance:
	var inst = ItemService.containers[ItemService.ContainerName.HOTBAR].get_item(equipped_index)
	return inst

# func set_equipped_instance(inst: ItemInstance):
# 	equipped_instance = inst
func set_equipped_index(index: int):
	equipped_index = index
	equipment_changed.emit(get_equipped_item())


func use():
	var context = {}
	var user = get_tree().get_first_node_in_group("player")

	var inst = ItemService.containers[ItemService.ContainerName.HOTBAR].get_item(equipped_index)
	if not inst:
		print("No equipment")
		return

	print("Using equipment: " + inst.data.display_name)
	inst.use(user, context)
