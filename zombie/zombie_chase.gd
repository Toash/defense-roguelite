extends State


@export var chase_speed = 200
@export var character: CharacterBody2D

@export var vision: Area2D
@export var raycast: RayCast2D

@export var nav: NavigationAgent2D
@export var sprite: AnimatedSprite2D


@export var zombie_target: Node

var active = false


func state_enter():
	active = true

func state_physics_update(delta: float):
	if active == false: return

	var target: Node2D = zombie_target.target

	if target and is_instance_valid(target):
		raycast.target_position = character.to_local(target.global_position)
		print(raycast.get_collider())

		nav.target_position = target.global_position

		var next_point: Vector2 = nav.get_next_path_position()
		var normal_dir = (next_point - character.global_position).normalized()

		if normal_dir.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

		character.velocity = normal_dir * chase_speed
		character.move_and_slide()
	

func state_exit():
	active = false
