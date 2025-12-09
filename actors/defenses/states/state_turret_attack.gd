extends State


## state that shoots projectiles towards a pawn.

# @export var user: Node2D


var defense: RuntimeDefense
@export var swivel_root: Node2D
@export var projectile_spawnpoint: Node2D

# var projectile_effect: ProjectileEffect

# var target: Node2D

var t: float = 0


func _ready():
	defense = get_node("../..") as RuntimeDefense
	if defense == null:
		push_error("Could not find runtime defense!")

	
func state_enter():
	defense.pawn_tracker.nearest_pawn_changed.connect(_on_nearest_pawn_changed)

func state_update(delta: float):
	t += delta

	if defense.pawn_tracker.get_nearest_pawn():
		swivel_root.look_at(defense.pawn_tracker.get_nearest_pawn().global_position)
		if defense.defense_data.attack_cooldown < t:
			_fire()
			t = 0

func state_physics_update(delta: float):
	pass

func state_exit():
	defense.pawn_tracker.nearest_pawn_changed.disconnect(_on_nearest_pawn_changed)
	pass


func _on_nearest_pawn_changed(a: Pawn, pawn: Pawn):
	if pawn == null:
		transitioned.emit(self, "idle")
		return
	# target = pawn


func _fire():
	var ctx: ItemContext = ItemContext.new()
	ctx.root_node = get_tree().current_scene
	ctx.user_node = defense
	ctx.global_spawn_point = projectile_spawnpoint.global_position


	var target_node = defense.pawn_tracker.get_nearest_pawn() as Pawn
	var predicted_target = PhysicsUtils.compute_predicted_target(ctx.global_spawn_point, target_node.global_position, target_node.velocity, defense.defense_data.projectile_speed)
	# ctx.global_target_position = defense.pawn_tracker.get_nearest_pawn().global_position
	ctx.global_target_position = predicted_target

	for effect in defense.get_all_item_effects():
		# effect.damage = defense.get_damage()
		effect.damage = defense.get_runtime_stat(DefenseData.BASE_STAT.DAMAGE)
		
		effect.speed = defense.defense_data.projectile_speed
		effect.apply(ctx)
