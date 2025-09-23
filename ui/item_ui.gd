extends TextureButton

# represents a singular slot in an inventory
# this will be a child of a Slot when that Slot contains an item.
class_name ItemUI


# @export var icon: TextureRect
@export var count: Label

var inst: ItemInstance = null

var draggable = true

func _ready() -> void:
	# mouse_entered.connect(_on_mouse_entered)
	# mouse_exited.connect(_on_mouse_exited)
	pass

# returns data that can be dragged from current control.
func _get_drag_data(at_position: Vector2) -> Variant:
	if not draggable: return null
	if inst == null:
		return null

	var data := {
		"inst": inst,
		"from_slot": get_parent()
		}

	var preview = TextureRect.new()
	preview.texture = inst.data.icon
	set_drag_preview(preview)

	return data

# returns whether or not this data is accepted.
# can check if current item fits in the inventory grid and if its compatible.
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# items are dropped onto slots.
	return false

# similar to can drop, except we are accepting the drop.
# should handle removing the item from the previous container, 
# 	and add to current control.
func _drop_data(at_position: Vector2, data: Variant) -> void:
	pass


# displays iteminstance
func set_item_instance(new_inst: ItemInstance) -> void:
	inst = new_inst
	texture_normal = new_inst.data.icon if new_inst.data and new_inst.data.icon else null
	count.text = str(new_inst.quantity)
	disabled = false

func _on_mouse_entered():
	if inst and draggable:
		TooltipManager.show_tooltip(inst.data.display_name + ": " + inst.data.description)

func _on_mouse_exited():
	TooltipManager.hide_tooltip()
