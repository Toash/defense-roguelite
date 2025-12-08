extends State

signal chase_target_acquired
signal chase_target_emitted(pos: Vector2)
signal chase_target_lost


@export var enemy: Enemy
@export var pawn: Pawn


var active = false


func state_enter():
	active = true
	chase_target_acquired.emit()
	# attack_tracker.nearest_pawn_changed.connect(_on_attack_vision_entered)
	enemy.attack_tracker.pawn_line_of_sight.connect(_on_attack_vision_entered)
	

func state_update(delta: float):
	pass
	
func state_physics_update(delta: float):
	if active == false: return

	if enemy.ai_target.reference:
		enemy.nav_agent.target_position = enemy.ai_target.reference.global_position
		chase_target_emitted.emit(enemy.ai_target.reference.global_position)

		var next_point: Vector2 = enemy.nav_agent.get_next_path_position()
		var normal_dir = (next_point - pawn.global_position).normalized()
		

		# pawn.move_and_collide(normal_dir * enemy.enemy_data.move_speed * delta)
		pawn.set_raw_velocity(normal_dir * enemy.get_data().move_speed)
		pawn.move_and_collide(pawn.get_total_velocity() * delta)
	else:
		transitioned.emit(self, "nexus")


func state_exit():
	active = false
	chase_target_lost.emit()
	enemy.attack_tracker.pawn_line_of_sight.disconnect(_on_attack_vision_entered)


func _on_attack_vision_entered(pawn: Pawn):
	print("asyidfyisoaidfo")
	if pawn is Player:
		transitioned.emit(self, "attack")
