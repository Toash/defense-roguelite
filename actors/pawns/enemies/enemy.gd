extends Pawn


class_name Enemy

## SHOULJD NOT BE ACCESSED DIRECTLY! USE get_data 
var enemy_data: EnemyData

@export var state_machine: StateMachine
# @export var tile_pathfind: TilePathfind

var player_tracker: PawnTracker
var defense_tracker: DefenseTracker
var attack_tracker: PawnTracker

func _enter_tree() -> void:
	super._enter_tree()
	player_tracker = PawnTracker.new()
	defense_tracker = DefenseTracker.new()
	attack_tracker = PawnTracker.new()
	add_child(player_tracker)
	add_child(defense_tracker)
	add_child(attack_tracker)

	_init_trackers_with_data()

func _ready():
	add_to_group("enemy")
	health.died.connect(_on_death)

	set_collision_layer_value(3, true)
	# set_collision_mask_value(2, true) # they just get stuck on walls :/
	set_collision_mask_value(6, true)


## call this when spawning the enemy.
## sets the enemies data, and initializes respective systems.
func setup(data: EnemyData):
	enemy_data = data
	self.health.set_max_health(int(data.health))
	self.health.set_health(data.health)

	_init_trackers_with_data()


func get_data() -> EnemyData:
	if enemy_data == null:
		var default_enemy_data = EnemyData.new()
		default_enemy_data.coins_dropped = 1
		default_enemy_data.cost = 1
		default_enemy_data.health = 100
		default_enemy_data.move_speed = 200
		default_enemy_data.attack_damage = 10
		default_enemy_data.attack_speed = 1

		return default_enemy_data
	else:
		return enemy_data
		

func _on_death():
	remove_from_group("enemy")

	# add coins to player
	(get_tree().get_first_node_in_group("player") as Player).coins.change_coins(get_data().coins_dropped)


	state_machine.queue_free()
	# if tile_pathfind!=null:
	# 	tile_pathfind.queue_free()

	set_collision_layer_value(3, false)
	await get_tree().create_timer(5).timeout
	queue_free.call_deferred()


func _init_trackers_with_data():
	player_tracker.factions_to_track = get_data().factions_to_track
	player_tracker.vision_distance = get_data().player_vision_distance

	defense_tracker.vision_distance = get_data().defense_vision_distance
	defense_tracker.priority_level = get_data().defense_priority_targeting

	attack_tracker.factions_to_track = get_data().factions_to_track
	attack_tracker.vision_distance = get_data().attack_vision_distance