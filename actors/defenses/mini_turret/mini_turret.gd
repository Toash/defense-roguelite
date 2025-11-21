extends Node2D


class_name MiniTurret
@export var user: Node2D
@export var defense: Defense
@export var enemy_tracker: PawnTracker
@export var swivel_root: Node2D
@export var projectile_effect: ProjectileEffect
@export var muzzle: Node2D

var target: Node2D

var t: float = 0

func _ready():
	enemy_tracker.nearest_pawn_changed.connect(_on_nearest_pawn_changed)


func _process(delta):
	t += delta

	if target:
		swivel_root.look_at(target.global_position)
		if defense.defense_data.attack_speed < t:
			_fire()
			t = 0


func _on_nearest_pawn_changed(pawn: Pawn):
	target = pawn
	pass


func _fire():
	var ctx: ItemContext = ItemContext.new()
	ctx.root_node = get_tree().current_scene
	ctx.user_node = user
	ctx.global_spawn_point = muzzle.global_position
	ctx.global_target_position = enemy_tracker.get_nearest_pawn().global_position


	projectile_effect.apply(ctx)
