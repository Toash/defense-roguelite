extends Resource

#repreents an instasnce of item data
class_name ItemInstance

@export var uid: String
@export var data: ItemData
@export var quantity: int

var last_used_time: float = -1


# constructor
func _init(d: ItemData = null, q := 1):
	uid = uuid.v4()
	data = d
	quantity = q

func use(ctx: ItemContext):
	if can_use() == false: return

	data.apply_effects(ctx)
	if data.consume_on_use:
		# assuming it is in hotbar
		# TODO: just emit a signal
		var hotbar: ItemContainer = ItemService.player_containers[ItemService.ContainerName.HOTBAR]
		var inst_index = hotbar._inst_uid_to_slot[uid]
		hotbar.remove(inst_index)

	last_used_time = 0

func can_use() -> bool:
	return last_used_time >= data.cooldown_time

func update_state(delta: float):
	last_used_time += delta

		
# serialize
func to_dict() -> Dictionary:
	return {
		"uid": uid,
		"data_path": data.resource_path,
		"quantity": quantity,
	}


# deserialize
# create an item instance from a dictionary
static func from_dict(dict: Dictionary) -> ItemInstance:
	var uid: String = str(dict.uid)

	var data_path: String = dict.data_path
	var data: ItemData = load(data_path)
	var quantity: int = int(dict.quantity)
	

	var inst: ItemInstance = ItemService.create_instance(data, quantity)
	inst.uid = uid
	return inst
