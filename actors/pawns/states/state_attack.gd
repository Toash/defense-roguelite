extends State

signal target_acquired
signal target_emitted(pos: Vector2)
signal target_lost


@export var enemy: Enemy
@export var pawn: Pawn
# @export var character: CharacterBody2D
@export var attack_move_speed = 300
@export var attack_cooldown = 1
@export var attack_vision: Area2D
@export var equipment: PawnEquipment


@export var nav: NavigationAgent2D
@export var ai_target: AITarget


var active = false
var t: float = 0.0

func state_enter():
	active = true
	target_acquired.emit()
	attack_vision.body_exited.connect(_on_attack_vision_exited)

func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return

	t += delta

	nav.target_position = ai_target.reference.global_position
	target_emitted.emit(ai_target.reference.global_position)

	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - pawn.global_position).normalized()

	pawn.set_raw_velocity(normal_dir * enemy.enemy_data.move_speed)
	pawn.move_and_collide(pawn.get_total_velocity() * delta)
	if t > attack_cooldown:
		equipment.use()
		t = 0


func state_exit():
	active = false
	target_lost.emit()
	attack_vision.body_exited.disconnect(_on_attack_vision_exited)

func _on_attack_vision_exited(body: Node2D):
	if body is Player:
		ai_target.reference = body
		transitioned.emit(self, "chase")
