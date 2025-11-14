extends Node2D

class_name ZombieAttackScene

@export var duration = 2
@export var damage = 25
@export var hitbox: Area2D

@export var animator: AnimationPlayer
@export var attack_animation_name: String

@export var left_hand_origin: Marker2D
@export var right_hand_origin: Marker2D


@export var root: Node2D


var user: Node2D
var context: ItemContext

func _ready():
	hitbox.body_entered.connect(_on_area_2d_body_entered)

func _process(delta):
	# get node2d that is animated, set to left and right hand
	context.character_sprite.set_left_hand(left_hand_origin.global_position)
	context.character_sprite.set_right_hand(right_hand_origin.global_position)
	
	# THS IS EPIC
	root.look_at(context.target_provider.get_global_mouse_pos())


func play(flipped: bool):
	user = context.user_node

	context.character_sprite.enable_left_hand()
	context.character_sprite.enable_right_hand()

	animator.current_animation = attack_animation_name
	animator.speed_scale = 2.5
	animator.play()

	if flipped:
		root.scale = Vector2(1, -1)
	else:
		root.scale = Vector2(1, 1)


	# static_body.add_collision_exception_with(ctx.user_node)
	_play()

# func 

func _play():
	get_tree().create_timer(duration).timeout.connect(func():
		context.character_sprite.disable_left_hand()
		context.character_sprite.disable_right_hand()
		root.queue_free()
	)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == user:
		return

	var pawn: Pawn = body as Pawn
	if pawn == null:
		return

	if pawn.faction == context.user_node.faction:
		return
		
	var health: Health = body.get_node("Health") as Health
	health.damage(damage)
