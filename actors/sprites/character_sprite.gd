extends Node2D

## Represents the sprites that make up a character
## pass in velocity to the callback for movement
class_name CharacterSprite

signal foot_touchdown


var character_body: CharacterBody2D

@export var head_texture: Texture2D
@export var torso_texture: Texture2D
@export var left_arm_texture: Texture2D
@export var right_arm_texture: Texture2D
@export var left_leg_texture: Texture2D
@export var right_leg_texture: Texture2D


var head: Sprite2D
var torso: Sprite2D
var left_arm: Sprite2D
var right_arm: Sprite2D
var left_leg: Sprite2D
var right_leg: Sprite2D

var head_initial_pos: Vector2
var torso_initial_pos: Vector2
var left_arm_initial_pos: Vector2
var right_arm_initial_pos: Vector2
var left_leg_initial_pos: Vector2
var right_leg_initial_pos: Vector2

var original_scale: Vector2
var flipped_scale: Vector2


var target: Vector2
var t := 0.0
var animation_speed: float = 0.0
var moving: bool = false

func _ready() -> void:
	original_scale = scale
	flipped_scale = Vector2(-original_scale.x, original_scale.y)

	character_body = get_parent()

	head = get_node("Head")
	torso = get_node("Torso")
	left_arm = get_node("LeftArm")
	right_arm = get_node("RightArm")
	left_leg = get_node("LeftLeg")
	right_leg = get_node("RightLeg")


	if head_texture:
		head.texture = head_texture
	if torso_texture:
		torso.texture = torso_texture

	if left_arm_texture:
		left_arm.texture = left_arm_texture
	if right_arm_texture:
		right_arm.texture = right_arm_texture

	if left_leg_texture:
		left_leg.texture = left_leg_texture
	if right_leg_texture:
		right_leg.texture = right_leg_texture

	head_initial_pos = head.position
	torso_initial_pos = torso.position
	left_arm_initial_pos = left_arm.position
	right_arm_initial_pos = right_arm.position
	left_leg_initial_pos = left_leg.position
	right_leg_initial_pos = right_leg.position

func _process(delta: float) -> void:
	_set_animation_speed()

	if character_body.velocity.length() > 0:
		moving = true
	else:
		moving = false

	if target.x < torso.global_position.x:
		scale = flipped_scale
	else:
		scale = original_scale
	_legs(delta)

func _set_animation_speed():
	var velocity: Vector2 = character_body.velocity
	var min_velocity: float = 250
	var max_velocity: float = 750
	var min_animation_speed: float = 5
	var max_animation_speed: float = 12
	var normalized_velocity = (velocity.length() - min_velocity) / (max_velocity - min_velocity)
	animation_speed = min_animation_speed + ((max_animation_speed - min_animation_speed) * normalized_velocity)


## diddy daddle
func _legs(delta: float):
	t += delta

	var max_vert = 3
	var max_horiz = 1
	const THRESHOLD = 0.05

	var vert_offset_0: float = sin(t * animation_speed) * max_vert
	var vert_offset_1: float = sin(t * animation_speed + PI) * max_vert

	var horiz_offset_0: float = sin(t * animation_speed + PI / 2) * max_horiz
	var horiz_offset_1: float = sin(t * animation_speed + (3 * PI) / 2) * max_horiz


	if moving:
		left_leg.position.y = left_leg_initial_pos.y + vert_offset_0
		right_leg.position.y = right_leg_initial_pos.y + vert_offset_1
		if vert_offset_0 >= max_vert - THRESHOLD or vert_offset_1 >= max_vert - THRESHOLD:
			foot_touchdown.emit()

		left_leg.position.x = left_leg_initial_pos.x + horiz_offset_0
		right_leg.position.x = right_leg_initial_pos.x + horiz_offset_1
	else:
		left_leg.position.y = left_leg_initial_pos.y
		right_leg.position.y = right_leg_initial_pos.y

		left_leg.position.x = left_leg_initial_pos.x
		right_leg.position.x = right_leg_initial_pos.x


func _set_hand_pos(pos: Vector2):
	pass

func _set_target(target: Vector2):
	self.target = target
