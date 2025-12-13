extends Node2D

## scene instantiate for melee swing item effects.
class_name MeleeScene

signal finished


@export var left_hand_marker: Marker2D
@export var right_hand_marker: Marker2D

@export var animation_player: AnimationPlayer
@export var area: Area2D
@export var root: Node
@export var sprite: Sprite2D

var melee_data: MeleeData
var item_context: ItemContext


var pierce_counter: int = 0


func _ready():
	area.body_entered.connect(_on_body_entered)

func _process(delta):
	root.look_at(item_context.target_provider.get_target_pos())
	item_context.character_sprite.set_left_hand(left_hand_marker.global_position)
	item_context.character_sprite.set_right_hand(right_hand_marker.global_position)

func setup(context: ItemContext, melee_data: MeleeData):
	context.character_sprite.enable_left_hand()
	context.character_sprite.enable_right_hand()
	self.item_context = context

	self.melee_data = melee_data

	position = Vector2.ZERO


	look_at(context.global_target_position)

func play():
	if item_context.flip_when_looking_left:
		root.scale = Vector2(1, -1)
	else:
		root.scale = Vector2(1, 1)

	_play()

# func 

func _play():
	animation_player.animation_finished.connect(func(anim_name: String):
		item_context.character_sprite.disable_left_hand()
		item_context.character_sprite.disable_right_hand()
		finished.emit()
		queue_free()
	)
	animation_player.play("use")


func _on_body_entered(body: Node2D) -> void:
	if body == item_context.user_node:
		return

	pierce_counter += 1

	var hit_context = HitContext.new({
		HitContext.Key.BASE_DAMAGE: melee_data.damage,
		HitContext.Key.HITTER: item_context.user_node,
		HitContext.Key.STATUS_EFFECTS: melee_data.status_effects,
		HitContext.Key.KNOCKBACK: 400,
		HitContext.Key.DIRECTION: - (item_context.user_node.global_position - body.global_position).normalized(),
	})

	var health: Health = body.get_node("Health") as Health
	health.apply_hit(hit_context)

	if pierce_counter >= melee_data.pierce:
		area.body_entered.disconnect(_on_body_entered)
