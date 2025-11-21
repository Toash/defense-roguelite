extends State


@export var enemy: Enemy

@export var tile_pathfind: TilePathfind
@export var player_tracker: PawnTracker
@export var defense_tracker: DefenseTracker
@export var ai_target: AITarget

var active = false
@onready var nexus_pos: Vector2 = (get_tree().get_first_node_in_group("nexus") as Nexus).global_position
# @onready var world: World = get_tree().get_first_node_in_group("world") as World

var speed

func state_enter():
	active = true
	print(enemy)
	print(enemy.enemy_data)
	
	speed = enemy.enemy_data.move_speed

	player_tracker.pawn_line_of_sight.connect(_on_player_found)
	defense_tracker.found_defense.connect(_on_defense_found)
	tile_pathfind.enable()

	if not enemy.world.setup:
		enemy.world.world_setup.connect(_set_target)
	else:
		_set_target()

	
func state_update(delta: float):
	pass

func state_physics_update(delta: float):
	if active == false: return

			
func state_exit():
	active = false
	player_tracker.pawn_line_of_sight.disconnect(_on_player_found)
	defense_tracker.found_defense.disconnect(_on_defense_found)
	tile_pathfind.disable()


func _on_player_found(player: Pawn):
	# pass
	print("found player!")
	ai_target.reference = player
	transitioned.emit(self, "chase")

func _on_defense_found(defense: Defense):
	print("found defense!")
	ai_target.reference = defense
	transitioned.emit(self, "break")

func _set_target():
	tile_pathfind.set_speed(speed)
	tile_pathfind.set_target(nexus_pos)
