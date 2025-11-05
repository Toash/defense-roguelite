extends Area2D

class_name PickupDetector

signal nearby_items_updated(nearby_items)
var nearby_items: Array[ItemInstance] = []


@export var pickup_container: ItemContainer

func _ready():
	nearby_items_updated.connect(func(dict):
		pickup_container.sync_items(dict))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("items"):
		if area is not GroundItem:
			push_error("Not itemdrop")

		var inst: ItemInstance = area.inst
		nearby_items.append(inst)
		nearby_items_updated.emit(nearby_items)
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("items"):
		if area is not GroundItem:
			push_error("Not itemdrop")

		var inst: ItemInstance = area.inst
		nearby_items.erase(inst)
		nearby_items_updated.emit(nearby_items)
