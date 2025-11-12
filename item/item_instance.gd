extends Resource

#ingame instance of item data
class_name ItemInstance

@export var uid: String
@export var data: ItemData
@export var quantity: int

var last_used_time: float = -1


func _init(d: ItemData = null, q := 1):
	uid = uuid.v4()
	data = d
	quantity = q

func use(ctx: ItemContext):
	if can_use() == false: return

	AudioManager.play_key(data.use_sound_key, ctx.user_node.global_position, data.use_sound_bus)

	data.apply_effects(ctx)
	if data.consume_on_use:
		print("trying to consume the item instance")

		var player: Player = ctx.user_node as Player
		if player:
			var hotbar_equipped_inst: HotbarEquippedInst = player.get_hotbar_equipped_inst()
			var hotbar: ItemContainer = player.get_hotbar()
			if hotbar_equipped_inst == null:
				push_error("Item Instance: HotbarEquippedInstance does not exist on the player!")
			if hotbar == null:
				push_error("Item Instance: Hotbar does not exist on the player!")

			hotbar.remove_by(hotbar_equipped_inst.get_equipped_index(), 1)
		

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
