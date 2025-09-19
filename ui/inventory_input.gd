extends Node

class_name InventoryInput

@export var inventory_ui: InventoryUI


func _process(_delta) -> void:
    if Input.is_action_pressed("inventory"):
        inventory_ui.toggle()
