extends Node2D

## displays an item instance that a user has, must be supplied a target.
## usually used for the spawnpoint for equipment.
class_name ItemDisplay


signal origin_created(node: Node2D)
signal origin_position_emitted(pos: Vector2)

## how far the item instnace will be from the player
@export var user: Node2D
@export var distance_from_user = 50
@export var instance_supplier: ItemInstanceProvider
@export var target_supplier: TargetProvider

@onready var inst_sprite: Sprite2D = Sprite2D.new()
@onready var origin_node: Node2D = Node2D.new()
var displayed_inst: ItemInstance

## origin will point towards this.
var target: Vector2

var flipped: bool

func _ready():
	instance_supplier.instance_changed.connect(_set_instance)
	target_supplier.target_pos_emitted.connect(_update_target)

	add_child(origin_node)
	origin_created.emit(origin_node)

	add_child(inst_sprite)
	# inst_sprite.position = position

## sets instance to display
## null to hide.
func _set_instance(inst: ItemInstance):
	if inst:
		self.displayed_inst = inst
		inst_sprite.texture = inst.data.ingame_sprite as Texture2D
		inst_sprite.flip_h = inst.data.sprite_flipped
		inst_sprite.visible = true
		inst_sprite.scale = Vector2(inst.data.scale, inst.data.scale)
	else:
		inst_sprite.texture = null
		inst_sprite.visible = false

func get_origin_node() -> Node2D:
	return origin_node

func hide_sprite():
	inst_sprite.visible = false

func show_sprite():
	inst_sprite.visible = true


func _process(delta):
	_set_origin_position()
	origin_position_emitted.emit(origin_node.global_position)

	# print(global_position)
	if displayed_inst:
		if displayed_inst.data.follow_target == false: return
	
	if target.x < user.global_position.x:
		inst_sprite.flip_v = true
		flipped = true
	else:
		inst_sprite.flip_v = false
		flipped = false

	inst_sprite.look_at(target)


func _update_target(pos: Vector2):
	target = pos

func _set_origin_position():
	var offset: Vector2 = target - user.global_position
	offset = offset.normalized()
	offset *= distance_from_user

	# inst_sprite.position = self.position + offset
	# inst_sprite.position = self.position + Vector2.RIGHT * -40
	origin_node.position = self.position + offset
