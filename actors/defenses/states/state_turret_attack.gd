extends State


@export var user: Node2D
@export var defense: Defense
@export var enemy_tracker: PawnTracker
@export var swivel_root: Node2D
@export var muzzle: Node2D

# var projectile_effect: ProjectileEffect

# var target: Node2D

var t: float = 0


func state_enter():
	enemy_tracker.nearest_pawn_changed.connect(_on_nearest_pawn_changed)

func state_update(delta: float):
	t += delta

	if enemy_tracker.get_nearest_pawn():
		swivel_root.look_at(enemy_tracker.get_nearest_pawn().global_position)
		if defense.defense_data.attack_cooldown < t:
			_fire()
			t = 0

func state_physics_update(delta: float):
	pass

func state_exit():
	enemy_tracker.nearest_pawn_changed.disconnect(_on_nearest_pawn_changed)
	pass


func _on_nearest_pawn_changed(a: Pawn, pawn: Pawn):
	if pawn == null:
		transitioned.emit(self, "idle")
		return
	# target = pawn


func _fire():
	var ctx: ItemContext = ItemContext.new()
	ctx.root_node = get_tree().current_scene
	ctx.user_node = user
	ctx.global_spawn_point = muzzle.global_position


	var target_node = enemy_tracker.get_nearest_pawn() as Pawn
	var predicted_target = PhysicsUtils.compute_predicted_target(ctx.global_spawn_point, target_node.global_position, target_node.velocity, defense.defense_data.projectile_speed)
	# ctx.global_target_position = enemy_tracker.get_nearest_pawn().global_position
	ctx.global_target_position = predicted_target

	for effect in defense.get_all_item_effects():
		effect.damage = defense.get_damage()
		effect.speed = defense.defense_data.projectile_speed
		effect.apply(ctx)
