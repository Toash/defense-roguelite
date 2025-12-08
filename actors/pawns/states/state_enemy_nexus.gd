## Go towards nexus
extends State


var enemy: Enemy
@export var pawn: Pawn

# @export var tile_pathfind: TilePathfind
# @export var player_tracker: PawnTracker
# @export var defense_tracker: DefenseTracker
# @export var ai_target: AITarget
# @export var nav: NavigationAgent2D

var active = false
@onready var nexus_pos: Vector2 = (get_tree().get_first_node_in_group("nexus") as Nexus).global_position
# @onready var world: World = get_tree().get_first_node_in_group("world") as World

func _ready():
	enemy = get_node("../..") as Enemy

func state_enter():
	active = true


	enemy.player_tracker.pawn_line_of_sight.connect(_on_player_found)
	enemy.defense_tracker.found_defense.connect(_on_defense_found)


func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return
	enemy.nav_agent.target_position = nexus_pos

	var next_point: Vector2 = enemy.nav_agent.get_next_path_position()
	var normal_dir = (next_point - pawn.global_position).normalized()
	
	pawn.set_raw_velocity(normal_dir * enemy.get_data().move_speed)
	pawn.move_and_collide(pawn.get_total_velocity() * delta)

			
func state_exit():
	active = false
	enemy.player_tracker.pawn_line_of_sight.disconnect(_on_player_found)
	enemy.defense_tracker.found_defense.disconnect(_on_defense_found)
	# tile_pathfind.disable()


func _on_player_found(player: Pawn):
	# pass
	# print("found player!")
	enemy.ai_target.reference = player
	transitioned.emit(self, "chase")

func _on_defense_found(defense: RuntimeDefense):
	# print("found defense!")
	if defense.get_defense_data().defense_priority != enemy.get_data().defense_targeting:
		return
	enemy.ai_target.reference = defense
	transitioned.emit(self, "break")

# func _set_target():
# 	tile_pathfind.set_speed(speed)
# 	tile_pathfind.set_target(nexus_pos)
