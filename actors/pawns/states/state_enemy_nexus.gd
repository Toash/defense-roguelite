## Go towards nexus
extends State


var enemy: RuntimeEnemy

var active = false
@onready var nexus_pos: Vector2 = (get_tree().get_first_node_in_group("nexus") as Nexus).global_position


func _ready():
	enemy = get_node("../..") as RuntimeEnemy


func state_enter():
	active = true

	enemy.player_tracker.got_pawn.connect(_on_player_found)
	enemy.defense_tracker.found_defense.connect(_on_defense_found)


	enemy.nav_agent.target_position = nexus_pos


func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return
	var next_point: Vector2 = enemy.nav_agent.get_next_path_position()
	var normal_dir = (next_point - enemy.global_position).normalized()

	# enemy.set_raw_velocity(normal_dir * enemy.get_enemy_data().move_speed)
	# var vel = enemy.raw_velocity
	# enemy.move_and_collide(pawn.get_total_velocity() * delta)

	enemy.nav_agent.velocity = normal_dir * enemy.get_enemy_data().move_speed
	enemy.move_and_collide(enemy.get_total_velocity() * delta)
	

func state_exit():
	active = false
	enemy.player_tracker.got_pawn.disconnect(_on_player_found)
	enemy.defense_tracker.found_defense.disconnect(_on_defense_found)
	# tile_pathfind.disable()


func _on_player_found(player: Pawn):
	# check some aggro manager if we are allowed to aggro.
	enemy.ai_target.reference = player
	if (get_node("/root/World/GameState") as GameState).aggro_manager.can_aggro(enemy):
		transitioned.emit(self, "chase")

func _on_defense_found(defense: RuntimeDefense):
	# print("found defense!")
	if defense.defense_data.defense_priority != enemy.get_enemy_data().defense_priority_targeting:
		return
	enemy.ai_target.reference = defense
	transitioned.emit(self, "break")

# func _set_target():
# 	tile_pathfind.set_speed(speed)
# 	tile_pathfind.set_target(nexus_pos)
