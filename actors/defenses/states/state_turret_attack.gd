extends State

## idle state for swivelling
class_name StateTurretAttack


@export var user: Node2D
@export var defense: Defense
@export var enemy_tracker: PawnTracker
@export var swivel_root: Node2D
@export var projectile_effect: ProjectileEffect
@export var muzzle: Node2D

var target: Node2D

var t: float = 0


func state_enter():
	enemy_tracker.nearest_pawn_changed.connect(_on_nearest_pawn_changed)

func state_update(delta: float):
	t += delta

	if target:
		swivel_root.look_at(target.global_position)
		if defense.defense_data.attack_speed < t:
			_fire()
			t = 0

func state_physics_update(delta: float):
	pass

func state_exit():
	enemy_tracker.nearest_pawn_changed.disconnect(_on_nearest_pawn_changed)
	pass


func _on_nearest_pawn_changed(pawn: Pawn):
	if pawn == null:
		transitioned.emit(self, "idle")
		return
	target = pawn


func _fire():
	var ctx: ItemContext = ItemContext.new()
	ctx.root_node = get_tree().current_scene
	ctx.user_node = user
	ctx.global_spawn_point = muzzle.global_position


	var target_node = enemy_tracker.get_nearest_pawn() as Pawn
	var predicted_target = PhysicsUtils.compute_predicted_target(ctx.global_spawn_point, target_node.global_position, target_node.velocity, defense.defense_data.projectile_speed)
	# ctx.global_target_position = enemy_tracker.get_nearest_pawn().global_position
	ctx.global_target_position = predicted_target

	projectile_effect.damage = defense.defense_data.attack_damage
	projectile_effect.speed = defense.defense_data.projectile_speed
	projectile_effect.apply(ctx)
