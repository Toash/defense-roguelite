extends ContainerUI
class_name HotbarUI


var selected_index := 0

func _ready() -> void:
	super._ready()
	_select_index(0)
	
func _select_index(index: int) -> void:
	if selected_index >= 0 and selected_index < _slots.size():
		_slots[selected_index].set_selected(false)

	selected_index = index

	if selected_index >= 0 and selected_index < _slots.size():
		_slots[selected_index].set_selected(true)


func on_equip_slot(index: int) -> void:
	if index < ItemService.size(container):
		_select_index(index)
