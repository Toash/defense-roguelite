extends Area2D

class_name PickupDetector

signal nearby_items_updated(nearby_items)
var nearby_items: Array[ItemDrop] = []


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("items"):
		if area is not ItemDrop:
			push_error("Not itemdrop")
		nearby_items.append(area as ItemDrop)
		nearby_items_updated.emit(nearby_items)
		
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("items"):
		if area is not ItemDrop:
			push_error("Not itemdrop")
		nearby_items.erase(area as ItemDrop)
		nearby_items_updated.emit(nearby_items)
