extends Node

# hotbar of the player.


signal selected_slot_changed(slot: int, )

@export var num_slots: int = 8

var selected_slot_index: int = 0

func select_slot(idx: int):
	if idx < 0 or idx >= num_slots: return
	selected_slot_index = idx
	selected_slot_changed.emit(idx)
