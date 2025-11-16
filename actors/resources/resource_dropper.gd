extends Node2D


class_name ResourceDropper

@export var node_to_queue_free: Node
@export var item_to_drop: ItemData
@export var amount: ItemData


func drop():
	# var inst = ItemService.create_instance(item_to_drop,1)
	GroundItems.spawn_by_id(item_to_drop.id, 1, global_position)
	node_to_queue_free.queue_free()