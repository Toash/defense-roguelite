extends Node


@export var apple: ItemData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GroundItems.spawn_by_data(
	apple,
	1,
	Vector2(50, 50)
	)
	
	GroundItems.spawn_by_data(
	apple,
	1,
	Vector2(150, 60)
	)
