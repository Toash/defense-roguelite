extends Resource

#repreents an instasnce of item data
class_name ItemInstance

@export var uid: String
@export var data: ItemData


@export var quantity: int

# @export var max_durability: int
# @export var durability: int

# constructor
func _init(d: ItemData = null, q := 1):
	uid = uuid.v4()
	data = d
	quantity = q

func use(user, ctx):
	data.apply_effects(user, ctx)

	if data.consume_on_use:
		# assuming it is in hotbar
		var hotbar: ItemContainer = ItemService.containers[ItemService.ContainerName.HOTBAR]
		var inst_index = hotbar._inst_uid_to_slot[uid]
		hotbar.remove(inst_index)

		
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
