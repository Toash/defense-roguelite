extends Node


@export var hotbar: ItemContainer
@export var itemdata: ItemData


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst = ItemInstance.new(itemdata, 1)
	hotbar.set_item_instance(0, inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
