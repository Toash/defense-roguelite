extends Pawn


class_name Enemy

var enemy_data: EnemyData:
	get:
		if enemy_data == null:
			return EnemyData.get_default()
		else:
			return enemy_data

@export var state_machine: StateMachine
# @export var tile_pathfind: TilePathfind

var nav_agent: NavigationAgent2D

## trackers
var player_tracker: PawnTracker
var defense_tracker: DefenseTracker
var attack_tracker: PawnTracker

## used for using items
var equipment: PawnEquipment
var item_display: ItemDisplay

# item that the enemy holds.
var enemy_item: EnemyItem

var ai_target: AITarget
var computed_velocity: Vector2
var nav_target_provider: NavTargetProvider

func _enter_tree() -> void:
	super._enter_tree()

	faction = Pawn.FACTION.ENEMY

	_setup_trackers()
	_set_trackers_with_data()

	_setup_nav_agent()
	_setup_nav_target_provider()

	_setup_enemy_item()
	_set_enemy_item_with_data()

	_setup_ai_target()
	_setup_item_display()
	_setup_equipment()

	character_sprite.target_supplier = nav_target_provider


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

	_set_trackers_with_data()
	_set_enemy_item_with_data()


## returns the enemy data, returning a default config if it is not present.
func get_enemy_data() -> EnemyData:
	if enemy_data == null:
		return EnemyData.get_default()
	else:
		return enemy_data
		

func _on_death():
	var game_state = (get_node("/root/World/GameState") as GameState)
	remove_from_group("enemy")
	game_state.aggro_manager.release_aggro(self)


	# add coins to player
	(get_tree().get_first_node_in_group("player") as Player).coins.change_coins(get_enemy_data().coins_dropped)


	state_machine.queue_free()
	# if tile_pathfind!=null:
	# 	tile_pathfind.queue_free()

	set_collision_layer_value(3, false)
	await get_tree().create_timer(5).timeout
	queue_free.call_deferred()


func _set_trackers_with_data():
	player_tracker.factions_to_track = get_enemy_data().factions_to_track
	player_tracker.vision_distance = get_enemy_data().player_vision_distance

	defense_tracker.vision_distance = get_enemy_data().defense_vision_distance
	defense_tracker.priority_level = get_enemy_data().defense_priority_targeting

	attack_tracker.factions_to_track = get_enemy_data().factions_to_track
	attack_tracker.vision_distance = get_enemy_data().attack_vision_distance


func _setup_trackers():
	player_tracker = PawnTracker.new()
	defense_tracker = DefenseTracker.new()
	attack_tracker = PawnTracker.new()
	add_child(player_tracker)
	add_child(defense_tracker)
	add_child(attack_tracker)

func _setup_nav_agent():
	nav_agent = NavigationAgent2D.new()
	nav_agent.avoidance_enabled = true
	nav_agent.radius = 20
	# nav_agent.debug_enabled = true
	nav_agent.velocity_computed.connect(func(vel):
		# print(vel)
		computed_velocity = vel
		)

	add_child(nav_agent)

func get_total_velocity() -> Vector2:
	if nav_agent.avoidance_enabled == true:
		## velocity + avoidance
		return computed_velocity
	else:
		return raw_velocity + knockback_velocity

func _setup_nav_target_provider():
	nav_target_provider = NavTargetProvider.new()
	nav_target_provider.agent = nav_agent
	add_child(nav_target_provider)

func _setup_enemy_item():
	enemy_item = EnemyItem.new()
	add_child(enemy_item)

func _setup_ai_target():
	ai_target = AITarget.new()
	add_child(ai_target)

func _setup_item_display():
	item_display = ItemDisplay.new()
	item_display.user = self
	item_display.instance_supplier = enemy_item
	item_display.target_supplier = ai_target
	add_child(item_display)

func _setup_equipment():
	equipment = PawnEquipment.new()
	equipment.user = self
	equipment.inst_provider = enemy_item
	equipment.target_provider = ai_target
	equipment.item_display = item_display
	equipment.character_sprite = character_sprite
	add_child(equipment)

func _set_enemy_item_with_data():
	enemy_item.data = get_enemy_data().item_data
