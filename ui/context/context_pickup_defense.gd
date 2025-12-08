extends Button

## should be in scenetree ( to get path to world )
class_name PickupDefense

var defense: RuntimeDefense
var world: World

func _ready():
	pressed.connect(_on_press)

func setup(world: World, defense: RuntimeDefense):
	self.world = world
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

	# (get_node("/root/World") as World).defense_tiles.erase_cell(defense.tile_pos)
	world.defense_tiles.erase_cell(defense.tile_pos)
	# defense.queue_free()
