extends State


@export var chase_speed = 200
@export var character: CharacterBody2D

@export var vision: Area2D
@export var raycast: RayCast2D

@export var nav: NavigationAgent2D


@export var target: ZombieTarget


var active = false


func state_enter():
	active = true

func state_physics_update(delta: float):
	if active == false: return

	
	raycast.target_position = character.to_local(target.reference.global_position)

	if raycast.get_collider():
		# print("Obstruction detected.")
		target.last_position = raycast.get_collision_point()
		transitioned.emit(self, "last_seen")


	nav.target_position = target.reference.global_position

	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - character.global_position).normalized()


	# character.velocity = normal_dir * chase_speed
	character.move_and_collide(normal_dir * chase_speed * delta)
	# character.move_and_slide()


func state_exit():
	active = false
