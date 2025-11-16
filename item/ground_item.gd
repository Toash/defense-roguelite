extends Area2D
class_name GroundItem
@export var inst: ItemInstance

func _ready():
	if inst and inst.data:
		$Sprite2D.texture = inst.data.icon
		$Sprite2D.scale = Vector2(inst.data.ground_scale, inst.data.ground_scale)
	# connect("body_entered", _on_body_entered)

# func _on_body_entered(body):
# 	if body.is_in_group("player"):
# 		print("Picking up item")
# 		Inventory.add(inst)
# 		queue_free()
