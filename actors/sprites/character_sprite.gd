extends Node

## Represents the sprites that make up a character
## pass in velocity to the callback for movement
class_name CharacterSprite

@export var character_body: CharacterBody2D

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


var t := 0.0

var animation_speed: float = 0.0
var moving: bool = false

func _ready() -> void:
	if character_body == null:
		push_error("CharacterSprite: a character body must be defined!")

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
	var velocity: Vector2 = character_body.velocity
	animation_speed = velocity.length() / 18

	if velocity.length() > 0:
		moving = true
	else:
		moving = false

	_do_stuff(delta)


## diddy daddle
func _do_stuff(delta: float):
	t += delta

	var offset_0: float = sin(t * animation_speed)
	var offset_1: float = sin(t * animation_speed + PI)

	var offset_2: float = sin(t * animation_speed + PI / 2)
	var offset_3: float = sin(t * animation_speed + (3 * PI) / 2)


	if moving:
		left_leg.position.y = left_leg_initial_pos.y + offset_0
		right_leg.position.y = right_leg_initial_pos.y + offset_1

		left_leg.position.x = left_leg_initial_pos.x + offset_2
		right_leg.position.x = right_leg_initial_pos.x + offset_3
	else:
		left_leg.position.y = left_leg_initial_pos.y
		right_leg.position.y = right_leg_initial_pos.y

		left_leg.position.x = left_leg_initial_pos.x
		right_leg.position.x = right_leg_initial_pos.x
