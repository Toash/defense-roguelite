extends State

signal target_acquired
signal target_emitted(pos: Vector2)
signal target_lost


@export var chase_speed = 200
@export var character: CharacterBody2D


@export var obstruction_raycast: RayCast2D

@export var nav: NavigationAgent2D


@export var target: ZombieTarget


var active = false


func state_enter():
	active = true
	target_acquired.emit()

func state_physics_update(delta: float):
	if active == false: return

	obstruction_raycast.target_position = obstruction_raycast.to_local(target.reference.global_position)

	if obstruction_raycast.get_collider():
		target.last_position = obstruction_raycast.get_collision_point()
		transitioned.emit(self, "last_seen")


	nav.target_position = target.reference.global_position
	target_emitted.emit(target.reference.global_position)

	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - character.global_position).normalized()
	

	character.velocity = normal_dir * chase_speed
	character.move_and_collide(normal_dir * chase_speed * delta)


func state_exit():
	active = false
	target_lost.emit()
