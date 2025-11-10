@abstract
## Has get_inst(), and an instance_changed signal.
class_name ItemInstanceProvider
extends Node2D

signal instance_changed(inst: ItemInstance)


@abstract
func get_inst() -> ItemInstance