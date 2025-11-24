extends State

signal target_acquired
signal target_emitted(pos: Vector2)
signal target_lost


@export var enemy: Enemy
@export var pawn: Pawn

@export var attack_vision: Area2D

@export var nav: NavigationAgent2D


@export var target: AITarget


var active = false


func state_enter():
	active = true
	target_acquired.emit()
	attack_vision.body_entered.connect(_on_attack_vision_entered)
	

func state_update(delta: float):
	pass
	
func state_physics_update(delta: float):
	if active == false: return

	if target.reference:
		nav.target_position = target.reference.global_position
		target_emitted.emit(target.reference.global_position)

		var next_point: Vector2 = nav.get_next_path_position()
		var normal_dir = (next_point - pawn.global_position).normalized()
		

		# pawn.move_and_collide(normal_dir * enemy.enemy_data.move_speed * delta)
		pawn.set_raw_velocity(normal_dir * enemy.enemy_data.move_speed)
		pawn.move_and_collide(pawn.get_total_velocity() * delta)
	else:
		transitioned.emit(self, "nexus")


func state_exit():
	active = false
	target_lost.emit()
	attack_vision.body_entered.disconnect(_on_attack_vision_entered)


func _on_attack_vision_entered(body: Node2D):
	if body is Player:
		transitioned.emit(self, "attack")
