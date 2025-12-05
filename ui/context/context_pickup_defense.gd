extends Button

class_name PickupDefense

var defense: RuntimeDefense

func _ready():
	pressed.connect(_on_press)

func setup(defense: RuntimeDefense):
	self.defense = defense


func _on_press():
	if defense == null:
		ContextManager.hide_context()
		return
	var player: Player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_error("Could not find player!")
	var item_data: ItemData = defense.defense_data.item_data
	var item_group: ItemDataGroup = ItemDataGroup.new()
	item_group.item_data = item_data
	item_group.amount = 1
	
	
	ContextManager.hide_context()
	player.containers.force_add_item_group(item_group)
	defense.queue_free()
