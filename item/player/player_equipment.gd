extends Node

class_name PlayerEquipment
signal equipment_changed(inst: ItemInstance)
signal holding_something
signal holding_nothing
## indexes into hotbar to use the iteminstance.


## used when the item spawns stuff.
@export var user: Node2D
@export var hotbar_container: ItemContainer
@export var equip_display: ItemEquipDisplay

var target: Vector2


# var equipped_instance: ItemInstance
var equipped_index: int


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_equipment"):
		use()

func _on_equip_slot(index: int):
	# if ItemService.player_containers[ItemService.ContainerName.HOTBAR].get_capacity() <= index:
	if hotbar_container.get_capacity() <= index:
		push_error("Hotbar does not have the right capacity to equip index " + str(index))
		return

	# var inst: ItemInstance = ItemService.containers[ItemService.ContainerName.HOTBAR].get_item(index)
	set_equipped_index(index)

func get_equipped_item() -> ItemInstance:
	var inst = hotbar_container.get_item(equipped_index)
	return inst

# func set_equipped_instance(inst: ItemInstance):
# 	equipped_instance = inst
func set_equipped_index(index: int):
	equipped_index = index
	equipment_changed.emit(get_equipped_item())

	if get_equipped_item() != null:
		holding_something.emit()
	else:
		holding_nothing.emit()

func _set_target(pos: Vector2):
	self.target = pos


func use():
	var item_context: ItemContext = ItemContext.new()
	item_context.root_node = get_tree().current_scene
	item_context.user_node = user
	item_context.global_spawn_point = equip_display.get_origin_node().global_position
	item_context.spawn_node = equip_display.get_origin_node()
	item_context.global_target_point = target

	item_context.equip_display = equip_display
	item_context.flipped = equip_display.flipped


	# var inst = ItemService.player_containers[ItemService.ContainerName.HOTBAR].get_item(equipped_index)
	var inst = hotbar_container.get_item(equipped_index)

	if not inst:
		print("No equipment")
		return

	print("Using equipment: " + inst.data.display_name)
	inst.use(item_context)
