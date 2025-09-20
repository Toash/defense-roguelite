extends TextureButton

# represents a singular slot in an inventory
class_name ItemSlot

# corresponds to a slot in the inventory
@export var slot_index: int = -1

# @export var icon: TextureRect
@export var count: Label

var inst: ItemInstance = null

func _ready() -> void:
	# mouse_entered.connect(_on_mouse_entered)
	# mouse_exited.connect(_on_mouse_exited)
	pass

func _on_mouse_entered():
	print("mouse entered")
	if inst:
		TooltipManager.show_tooltip(inst.data.display_name + ": " + inst.data.description)

func _on_mouse_exited():
	print("mouse exited")
	TooltipManager.hide_tooltip()

func clear_slot() -> void:
	inst = null
	# icon.texture = null
	texture_normal = null
	count.text = ""
	disabled = true

func set_iteminstance(new_inst: ItemInstance) -> void:
	inst = new_inst
	# icon.texture = new_inst.data.icon if new_inst.data and new_inst.data.icon else null
	texture_normal = new_inst.data.icon if new_inst.data and new_inst.data.icon else null
 
	count.text = str(new_inst.quantity)
	disabled = false
