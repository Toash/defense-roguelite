extends State

## uses equipment based on attack cooldown 


var enemy: RuntimeEnemy
@export var pawn: Pawn
@export var attack_cooldown = 1


var active = false
var t: float = 0.0

func _ready():
	enemy = get_node('../..') as RuntimeEnemy


func state_enter():
	active = true
	enemy.attack_tracker.nearest_pawn_changed.connect(_on_attack_vision_exited)
	

func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return

	t += delta

	if t > attack_cooldown:
		enemy.equipment.use()
		t = 0


func state_exit():
	active = false
	enemy.attack_tracker.nearest_pawn_changed.disconnect(_on_attack_vision_exited)

func _on_attack_vision_exited(previous_pawn: Pawn, pawn: Pawn):
	if previous_pawn is Player:
		enemy.ai_target.reference = previous_pawn
		transitioned.emit(self, "chase")
