extends TextureButton

# represents a singular slot in an inventory
class_name ItemSlot

# corresponds to a slot in the inventory
@export var slot_index: int = -1

# @onready var icon: TextureRect = $Icon
# @onready var count: Label = $Count

@export var icon: TextureRect
@export var count: Label

var inst: ItemInstance = null

func clear_slot() -> void:
	inst = null
	icon.texture = null
	count.text = ""
	disabled = true

func set_iteminstance(new_inst: ItemInstance) -> void:
	inst = new_inst
	icon.texture = new_inst.data.icon if new_inst.data and new_inst.data.icon else null
	count.text = str(new_inst.quantity)
	disabled = false
