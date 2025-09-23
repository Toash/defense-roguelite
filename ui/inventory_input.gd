extends Node

class_name InventoryInput

@export var inventory_ui: InventoryUI


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("inventory"):
        inventory_ui.toggle()
