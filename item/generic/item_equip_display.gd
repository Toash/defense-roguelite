extends Node2D

# displays an item instance
class_name ItemEquipDisplay


signal origin_created(node: Node2D)

## how far the item instnace will be from the player
@export var distance_from_user = 50

@onready var sprite: Sprite2D = Sprite2D.new()
var inst: ItemInstance

var user: Node2D
@onready var origin_node: Node2D = Node2D.new()
var target: Vector2
var flipped: bool

## sets instance to display
## null to hide.
func set_instance(inst: ItemInstance):
	if inst:
		sprite.texture = inst.data.ingame_sprite as Texture2D
		sprite.flip_h = inst.data.sprite_flipped
		sprite.visible = true
		sprite.scale = Vector2(inst.data.scale, inst.data.scale)
	else:
		sprite.texture = null
		sprite.visible = false

func get_origin_node() -> Node2D:
	return origin_node

func hide_sprite():
	sprite.visible = false

func show_sprite():
	sprite.visible = true


func _ready():
	add_child(origin_node)
	origin_created.emit(origin_node)

	user = get_parent()
	add_child(sprite)
	# sprite.position = position


func _process(delta):
	_set_origin_position()
	if inst:
		if inst.data.follow_target == false: return
	if target.x < self.global_position.x:
		sprite.flip_v = true
		flipped = true
	else:
		sprite.flip_v = false
		flipped = false

	sprite.look_at(target)


func _set_origin_position():
	var offset: Vector2 = target - user.global_position
	offset = offset.normalized()
	offset *= distance_from_user

	sprite.position = self.position + offset
	origin_node.position = self.position + offset

func _update_target(pos: Vector2):
	target = pos
