extends Area2D
class_name ItemDrop
@export var instance: ItemInstance

func _ready():
	if instance and instance.data:
		$Sprite2D.texture = instance.data.icon
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		Inventory.add(instance)
		queue_free()