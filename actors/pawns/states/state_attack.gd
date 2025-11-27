extends State

signal target_acquired
signal target_emitted(pos: Vector2)
signal target_lost


@export var enemy: Enemy
@export var pawn: Pawn
# @export var character: CharacterBody2D
@export var attack_move_speed = 300
@export var attack_cooldown = 1
# @export var attack_vision: Area2D
@export var attack_tracker:PawnTracker 
@export var equipment: PawnEquipment


@export var nav: NavigationAgent2D
@export var ai_target: AITarget


var active = false
var t: float = 0.0

func state_enter():
	active = true
	target_acquired.emit()
	attack_tracker.nearest_pawn_changed.connect(_on_attack_vision_exited)
	

func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return

	t += delta

	nav.target_position = ai_target.reference.global_position
	target_emitted.emit(ai_target.reference.global_position)

	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - pawn.global_position).normalized()

	pawn.set_raw_velocity(normal_dir * enemy.get_data().move_speed)
	pawn.move_and_collide(pawn.get_total_velocity() * delta)
	if t > attack_cooldown:
		equipment.use()
		t = 0


func state_exit():
	active = false
	target_lost.emit()
	attack_tracker.nearest_pawn_changed.disconnect(_on_attack_vision_exited)

func _on_attack_vision_exited(previous_pawn:Pawn, pawn: Pawn):
	if previous_pawn is Player:
		ai_target.reference = previous_pawn 
		transitioned.emit(self, "chase")
