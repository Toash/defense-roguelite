extends Node2D


## Handles using items for a defense structure.
class_name DefenseEquipment

var user
var target
var target_provider: TargetProvider
var inst_provider: ItemInstanceProvider


func use():
	var item_context: ItemContext = ItemContext.new()
	item_context.root_node = get_tree().current_scene
	item_context.user_node = user
	item_context.global_target_position = target

	item_context.global_spawn_point = Vector2.ZERO
	item_context.spawn_node = self
	item_context.equip_display = null
	item_context.character_sprite = null
	# item_context.flip_when_looking_left = 

	item_context.target_provider = target_provider


	var current_inst = inst_provider.get_inst()
	if not current_inst:
		print_debug("Could not find the current instnace on a defense structure.")
		return
	current_inst.use(item_context)