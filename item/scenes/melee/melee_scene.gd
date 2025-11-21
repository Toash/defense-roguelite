extends Node2D

class_name MeleeScene

signal finished

var damage: int = 25
var user: Node2D

@export var left_hand_marker: Marker2D
@export var right_hand_marker: Marker2D

@export var animation_player: AnimationPlayer
@export var area: Area2D
@export var root: Node
@export var sprite: Sprite2D
var context: ItemContext


func _ready():
	area.body_entered.connect(_on_body_entered)

func _process(delta):
	root.look_at(context.target_provider.get_target_pos())
	context.character_sprite.set_left_hand(left_hand_marker.global_position)
	context.character_sprite.set_right_hand(right_hand_marker.global_position)

func setup(context: ItemContext, damage: int):
	context.character_sprite.enable_left_hand()
	context.character_sprite.enable_right_hand()
	self.context = context

	position = Vector2.ZERO

	self.damage = damage

	look_at(context.global_target_position)

func play():
	user = context.user_node
	if context.flip_when_looking_left:
		root.scale = Vector2(1, -1)
	else:
		root.scale = Vector2(1, 1)

	_play()

# func 

func _play():
	animation_player.animation_finished.connect(func(anim_name: String):
		context.character_sprite.disable_left_hand()
		context.character_sprite.disable_right_hand()
		finished.emit()
		queue_free()
	)
	animation_player.play("use")


func _on_body_entered(body: Node2D) -> void:
	if body == user:
		return
	var health: Health = body.get_node("Health") as Health
	health.damage(damage)
