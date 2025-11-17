extends Node


@export var hotbar: ItemContainer
@export var itemdata: ItemData
@export var amount: int
@export var index: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst = ItemInstance.new(itemdata, amount)
	hotbar.set_item_instance(index, inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
