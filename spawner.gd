extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ItemFactory.spawn_pickup(
	"res://item/items/apple/apple.tres",
	1,
	Vector2(0, 0)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
