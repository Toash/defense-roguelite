extends Node2D

# displays an item instance
class_name ItemEquipDisplay


@onready var sprite: Sprite2D = Sprite2D.new()
var inst: ItemInstance

var target: Vector2

## sets instance to display
## null to hide.
func set_instance(inst: ItemInstance):
	if inst:
		print(inst.data.display_name)
		sprite.texture = inst.data.ingame_sprite as Texture2D
		sprite.flip_h = inst.data.sprite_flipped
		sprite.visible = true
	else:
		sprite.texture = null
		sprite.visible = false

func _ready():
	add_child(sprite)
	sprite.position = position


func _process(delta):
	if inst:
		if inst.data.follow_target == false: return
	if target.x < self.global_position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false

	sprite.look_at(target)


func _update_target(pos: Vector2):
	target = pos
