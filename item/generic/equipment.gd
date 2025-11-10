extends Node


## Handles using some current instance for a user
class_name Equipment

## used when the item spawns stuff.
@export var user: Node2D


## should have a method that returns an instance.
@export var instance_supplier: ItemInstanceProvider
@export var target_supplier: TargetProvider

## Used for passing in information when the items get used.
@export var equip_display: ItemDisplay

var target: Vector2
var current_inst: ItemInstance


func _ready():
	target_supplier.target_emitted.connect(_set_target)
	instance_supplier.instance_changed.connect(_set_current_inst)

		
func use():
	var item_context: ItemContext = ItemContext.new()
	item_context.root_node = get_tree().current_scene
	item_context.user_node = user
	item_context.global_target_point = target

	item_context.global_spawn_point = equip_display.get_origin_node().global_position
	item_context.spawn_node = equip_display.get_origin_node()
	item_context.equip_display = equip_display
	item_context.flipped = equip_display.flipped

	current_inst = instance_supplier.get_inst()
	if not current_inst:
		print("A user does not have an item equipped but they are trying to use it.")
		return
	current_inst.use(item_context)


## set target that is to be passed to the ItemContext ( For example, guns)
func _set_target(pos: Vector2):
	self.target = pos


## set the current inst that will be used when the user uses.
func _set_current_inst(inst: ItemInstance):
	self.current_inst = inst
