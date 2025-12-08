extends Node


## Handles using some current instance for a user
class_name PawnEquipment

## pawn that uses the equipment.
@export var user: Pawn

## provides the instance to be used
@export var inst_provider: ItemInstanceProvider
## provides the target when using the item
@export var target_provider: TargetProvider

@export var item_display: ItemDisplay

## used the handle limbs when using the item
@export var character_sprite: CharacterSprite

var target: Vector2
var current_inst: ItemInstance


func _ready():
	if user == null:
		push_error("PawnEquipment: User node must be set")
	if inst_provider == null:
		push_error("PawnEquipment: ItemInstanceProvider must be set")
	if target_provider == null:
		push_error("PawnEquipment: TargetProvider must be set")
	if item_display == null:
		push_error("PawnEquipment: ItemDisplay must be set")
	if character_sprite == null:
		push_error("PawnEquipment: CharacterSprite must be set")
		

	target_provider.target_pos_emitted.connect(_set_target)
	inst_provider.instance_changed.connect(_set_current_inst)

		
func use():
	var item_context: ItemContext = ItemContext.new()
	item_context.root_node = get_tree().current_scene
	item_context.user_node = user
	# item_context.global_target_position = target
	item_context.global_target_position = target_provider.get_target_pos()
	item_context.direction = (target_provider.get_target_pos() - user.global_position).normalized()

	item_context.global_spawn_point = item_display.get_origin_node().global_position
	item_context.spawn_node = item_display.get_origin_node()
	item_context.equip_display = item_display
	item_context.character_sprite = character_sprite
	item_context.flip_when_looking_left = item_display.flipped

	item_context.target_provider = target_provider


	current_inst = inst_provider.get_inst()
	if not current_inst:
		# print("A user does not have an item equipped but they are trying to use it.")
		return
	current_inst.use(item_context)


## set target that is to be passed to the ItemContext ( For example, guns)
func _set_target(pos: Vector2):
	self.target = pos


## set the current inst that will be used when the user uses.
func _set_current_inst(inst: ItemInstance):
	self.current_inst = inst
