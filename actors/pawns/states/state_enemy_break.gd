extends State


@export var speed = 200
@export var break_cooldown := 2.5


@export var equipment: PawnEquipment

@export var nav: NavigationAgent2D

@export var ai_target: AITarget

var active = false
var t: float = 0.0
var enemy: RuntimeEnemy


const BREAK_DISTANCE = 80


func _ready():
	enemy = get_node("../..") as RuntimeEnemy
func state_enter():
	active = true
	

func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return

	t += delta

	if enemy.ai_target.reference:
		nav.target_position = ai_target.reference.global_position
		var next_point: Vector2 = nav.get_next_path_position()
		var normal_dir = (next_point - enemy.global_position).normalized()

		enemy.velocity = normal_dir * speed
		enemy.move_and_collide(normal_dir * speed * delta)
		
		if (enemy.ai_target.reference.global_position - enemy.global_position).length() < BREAK_DISTANCE:
			if t > break_cooldown:
				equipment.use()
				t = 0
	else:
		transitioned.emit(self, "nexus")


func state_exit():
	active = false
