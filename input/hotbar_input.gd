extends Node
class_name HotbarInput


signal equip_slot(index: int)

func _process(delta: float) -> void:
	if Console.input.has_focus(): return

	if Input.is_action_just_pressed("hotbar_1"): _equip_from_hotbar(0)
	if Input.is_action_just_pressed("hotbar_2"): _equip_from_hotbar(1)
	if Input.is_action_just_pressed("hotbar_3"): _equip_from_hotbar(2)
	if Input.is_action_just_pressed("hotbar_4"): _equip_from_hotbar(3)
	if Input.is_action_just_pressed("hotbar_5"): _equip_from_hotbar(4)
	if Input.is_action_just_pressed("hotbar_6"): _equip_from_hotbar(5)
	if Input.is_action_just_pressed("hotbar_7"): _equip_from_hotbar(6)
	if Input.is_action_just_pressed("hotbar_8"): _equip_from_hotbar(7)
	if Input.is_action_just_pressed("hotbar_9"): _equip_from_hotbar(8)

func _equip_from_hotbar(index: int):
	equip_slot.emit(index)
