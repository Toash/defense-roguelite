extends Node2D

class_name Melee

signal finished

@export var swing_speed = 2
@export var damage = 25
@export var animation_player: AnimationPlayer

@export var static_body: StaticBody2D

@export var root: Node2D
# @export var texture: Texture2D


func play(ctx: ItemContext, flipped: bool):
	if flipped:
		root.scale = Vector2(1, -1)
	else:
		root.scale = Vector2(1, 1)

	static_body.add_collision_exception_with(ctx.user_node)
	_play()

# func 

func _play():
	animation_player.animation_finished.connect(func(anim_name: String):
		finished.emit()
		queue_free()
	)
	animation_player.speed_scale = swing_speed
	animation_player.play("swing")
