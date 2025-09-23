extends Node
class_name HotbarInput


@export var equipment: Equipment

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hotbar_1"): _equip_from_hotbar(0, &"MainHand")
	if Input.is_action_just_pressed("hotbar_2"): _equip_from_hotbar(1, &"MainHand")
	if Input.is_action_just_pressed("hotbar_3"): _equip_from_hotbar(2, &"MainHand")
	if Input.is_action_just_pressed("hotbar_4"): _equip_from_hotbar(3, &"MainHand")
	if Input.is_action_just_pressed("hotbar_5"): _equip_from_hotbar(4, &"MainHand")
	if Input.is_action_just_pressed("hotbar_6"): _equip_from_hotbar(5, &"MainHand")
	if Input.is_action_just_pressed("hotbar_7"): _equip_from_hotbar(6, &"MainHand")
	if Input.is_action_just_pressed("hotbar_8"): _equip_from_hotbar(7, &"MainHand")

func _equip_from_hotbar(hotbar_index: int, equip_slot: StringName):
	# var uid := Hotbar.slots[hotbar_index]
	# if uid == "":
	# 	return
	# equipment.equip(equip_slot, uid)
	Hotbar.select_slot(hotbar_index)
	pass
