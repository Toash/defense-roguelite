extends State


@export var speed = 200
@export var break_cooldown := 2.5

@export var character: CharacterBody2D

@export var equipment: Equipment

@export var nav: NavigationAgent2D


@export var ai_target: AITarget

var active = false
var t: float = 0.0


const BREAK_DISTANCE = 80

func state_enter():
	active = true
	

func state_physics_update(delta: float):
	if active == false: return

	t += delta

	nav.target_position = ai_target.reference.global_position
	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - character.global_position).normalized()

	character.velocity = normal_dir * speed
	character.move_and_collide(normal_dir * speed * delta)
	
	if (ai_target.reference.global_position - character.global_position).length() < BREAK_DISTANCE:
		if t > break_cooldown:
			equipment.use()
			t = 0


func state_exit():
	active = false
