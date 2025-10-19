extends Node2D

class_name Melee


@export var swing_speed = 2
@export var damage = 25
@export var animation_player: AnimationPlayer

@export var static_body: StaticBody2D
# @export var texture: Texture2D


func play(ctx: ItemContext):
	static_body.add_collision_exception_with(ctx.user_node)
	_play()

func _play():
	await animation_player.play()
	queue_free()
