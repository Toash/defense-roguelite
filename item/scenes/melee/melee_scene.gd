extends Node2D

## generic scene for melee swing item effects.
## add this to a scene and set the necessary exports. 
class_name MeleeScene

signal finished_melee_animation


## left hand marker for the character sprite. Should be animated
@export var left_hand_marker: Marker2D
## right hand marker for the character sprite. Should be animated
@export var right_hand_marker: Marker2D

## should define an animation named "use"
@export var animation_player: AnimationPlayer

## area used to apply damage if it hits another pawn.
## should be animated
@export var area: Area2D


## root node of hte melee scene.
## used for rotation and scaling
@export var root: Node

var melee_data: MeleeData
var item_context: ItemContext

## keeps track of the number of applicable nodes hit in the swing. 
var pierce_counter: int = 0


func _ready():
	area.body_entered.connect(_on_body_entered)

func _process(delta):
	root.look_at(item_context.target_provider.get_target_pos())
	item_context.character_sprite.set_left_hand(left_hand_marker.global_position)
	item_context.character_sprite.set_right_hand(right_hand_marker.global_position)

## sets up the item context and the melee data 
## should be called before adding to the scene tree.
func setup(item_context: ItemContext, melee_data: MeleeData):
	self.item_context = item_context
	self.melee_data = melee_data
	position = Vector2.ZERO

	# look_at(item_context.global_target_position)

func play():
	item_context.character_sprite.enable_left_hand()
	item_context.character_sprite.enable_right_hand()
	if item_context.flip_when_looking_left:
		root.scale = Vector2(1, -1)
	else:
		root.scale = Vector2(1, 1)

	animation_player.animation_finished.connect(func(anim_name: String):
		item_context.character_sprite.disable_left_hand()
		item_context.character_sprite.disable_right_hand()
		finished_melee_animation.emit()
		queue_free()
	)
	animation_player.play("use")


func _on_body_entered(body: Node2D) -> void:
	if body == item_context.user_node:
		return


	var hit_context = HitContext.new({
		HitContext.Key.BASE_DAMAGE: melee_data.damage,
		HitContext.Key.HITTER: item_context.user_node,
		HitContext.Key.STATUS_EFFECTS: melee_data.status_effects,
		HitContext.Key.KNOCKBACK: 400,
		HitContext.Key.DIRECTION: - (item_context.user_node.global_position - body.global_position).normalized(),
	})

	var health: Health = body.get_node("Health") as Health
	health.apply_hit(hit_context)

	pierce_counter += 1
	if pierce_counter >= melee_data.pierce:
		area.body_entered.disconnect(_on_body_entered)
