extends State

signal target_acquired
signal target_emitted(pos: Vector2)
signal target_lost


@export var chase_speed = 200
@export var character: CharacterBody2D

@export var attack_vision: Area2D

@export var obstruction_raycast: RayCast2D

@export var nav: NavigationAgent2D


@export var target: AITarget


var active = false


func state_enter():
	active = true
	target_acquired.emit()
	attack_vision.body_entered.connect(_on_body_entered)
	

func state_physics_update(delta: float):
	if active == false: return

	if target.reference:
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
	else:
		transitioned.emit(self, "nexus")


func state_exit():
	active = false
	target_lost.emit()
	attack_vision.body_entered.disconnect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if body is Player:
		transitioned.emit(self, "attack")
