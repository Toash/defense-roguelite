extends Node2D

class_name Melee

signal finished

@export var swing_speed = 2
@export var damage = 25
@export var animation_player: AnimationPlayer
@export var area: Area2D

# @export var static_body: StaticBody2D

@export var root: Node


var user: Node2D

func _ready():
	area.body_entered.connect(_on_area_2d_body_entered)

func play(ctx: ItemContext, flipped: bool):
	user = ctx.user_node
	# dont collide with the user.
	if flipped:
		root.scale = Vector2(1, -1)
	else:
		root.scale = Vector2(1, 1)

	# static_body.add_collision_exception_with(ctx.user_node)
	_play()

# func 

func _play():
	animation_player.animation_finished.connect(func(anim_name: String):
		finished.emit()
		queue_free()
	)
	animation_player.speed_scale = swing_speed
	animation_player.play("swing")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == user:
		return
	var health: Health = body.get_node("Health") as Health
	health.damage(damage)
