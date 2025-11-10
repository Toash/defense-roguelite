extends Node2D

class_name EquipmentInput

signal use_equipment


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_equipment"):
		use_equipment.emit()
		# use()