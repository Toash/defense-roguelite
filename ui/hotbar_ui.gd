extends ContainerUI
class_name HotbarUI

signal hotbar_select(index: int)


var selected_index := 0

func _ready() -> void:
	super._ready()
	_select_index(0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _select_index(index: int) -> void:
	if selected_index >= 0 and selected_index < _slots.size():
		_slots[selected_index].set_selected(false)

	selected_index = index

	if selected_index >= 0 and selected_index < _slots.size():
		_slots[selected_index].set_selected(true)

	hotbar_select.emit(index)

func _unhandled_input(event: InputEvent) -> void:
	for n in range(1, 10):
		if Input.is_action_just_pressed("hotbar_%d" % n):
			var i := n - 1
			if i < ItemService.size(container):
				_select_index(i)
				return
