extends Area2D

class_name PickupDetector

signal nearby_items_updated(nearby_items)
var nearby_items: Array[ItemInstance] = []

func _ready():
	nearby_items_updated.connect(func(dict):
		ItemService.containers[ItemService.ContainerName.PICKUPS].sync (dict)
	)
# func _process(delta):
# 	print(nearby_items)

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
