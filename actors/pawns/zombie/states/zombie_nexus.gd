extends State


@export var speed = 150

@export var tile_pathfind: TilePathfind
@export var player_tracker: PlayerTracker
@export var zombie_target: ZombieTarget

var active = false
@onready var nexus_pos: Vector2 = (get_tree().get_first_node_in_group("nexus") as Nexus).global_position
@onready var world: World = get_tree().get_first_node_in_group("world") as World


func state_enter():
	active = true
	

	player_tracker.found_player.connect(_on_player_found)
	tile_pathfind.enable()

	if not world.setup:
		world.world_setup.connect(_set_target)
	else:
		_set_target()

	
func state_physics_update(delta: float):
	if active == false: return

			
func state_exit():
	active = false
	player_tracker.found_player.disconnect(_on_player_found)
	tile_pathfind.disable()


func _on_player_found(player: Player):
	# pass
	print("found player!")
	zombie_target.reference = player
	transitioned.emit(self, "chase")

func _set_target():
	tile_pathfind.set_speed(speed)
	tile_pathfind.set_target(nexus_pos)
