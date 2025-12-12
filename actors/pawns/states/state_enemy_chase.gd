extends State


var enemy: Enemy


var active = false
var POLLING_DELAY = RandomNumberGenerator.new().randf_range(0, .2)
var rng = RandomNumberGenerator.new()

# time to pull again
# spreads out set_target calls across physics frames
var poll_again: float = 0
var poll_timer: float = 0


func _ready():
	enemy = get_node("../..") as Enemy

func state_enter():
	active = true
	# attack_tracker.nearest_pawn_changed.connect(_on_attack_vision_entered)
	enemy.attack_tracker.got_pawn.connect(_on_attack_vision_entered)
	if enemy.ai_target.reference is Player:
		var player: Player = enemy.ai_target.reference
		player.poll_position.connect(func(global_pos: Vector2):
			if poll_timer >= poll_again:
				enemy.nav_agent.target_position = global_pos
				poll_again = rng.randf_range(.3, .7)
				poll_timer = 0
			)

	
func state_update(delta: float):
	poll_timer += delta
	pass
	
func state_physics_update(delta: float):
	if active == false: return

	var next_point: Vector2 = enemy.nav_agent.get_next_path_position()
	var normal_dir = (next_point - enemy.global_position).normalized()
	# enemy.set_raw_velocity(normal_dir * enemy.get_enemy_data().move_speed)
	# enemy.move_and_collide(enemy.get_total_velocity() * delta)
	enemy.nav_agent.velocity = normal_dir * enemy.enemy_data.move_speed
	enemy.move_and_collide(enemy.get_total_velocity() * delta)


func state_exit():
	active = false
	(get_node("/root/World/GameState") as GameState).aggro_manager.release_aggro(enemy)
	enemy.attack_tracker.got_pawn.disconnect(_on_attack_vision_entered)


func _on_attack_vision_entered(pawn: Pawn):
	# print("asyidfyisoaidfo")
	if pawn is Player:
		transitioned.emit(self, "attack")
