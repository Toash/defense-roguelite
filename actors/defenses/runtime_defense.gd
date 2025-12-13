extends Area2D

## runtime root node for all defenses 
## contains information for all defenses, as well as their stats and effects for use in some other classes.
class_name RuntimeDefense

## signals that all functionality should be off if set to true.
var is_preview: bool = false


# How do other enemies see this ? 
enum PRIORITY {
	INVISIBLE,
	VISIBLE
}


# should be set if the defense should take damage.
@export var health: Health


# should be set in the scene. 
@export var defense_data: DefenseData:
	get:
		if defense_data == null:
			push_error("DefenseData not found.")
			return DefenseData.get_default()
		return defense_data


## used for outlining
# @export var main_sprite: Sprite2D

## the tile position that this defense is currently on.
var tile_pos: Vector2i

var pickup_defense_scene: PackedScene = preload("res://ui/context/scenes/pickup_defense.tscn")
var defense_stat_display_scene: PackedScene = preload("res://ui/context/scenes/defense_stat_display.tscn")
var world: World


var pawn_tracker: PawnTracker


# @export var applied_upgrades: Array[DefenseUpgrade]

func _enter_tree() -> void:
	_setup_pawn_tracker()

func _ready():
	world = get_node("/root/World") as World
	add_to_group("defenses")


	# TODO: dont generalize onto player?
	var player: Player = get_tree().get_first_node_in_group("player")
	player.player_defenses.sync_defense_upgrades(self)

	
	if health != null:
		health.died.connect(func():
			queue_free()
			)
		health.max_health = defense_data.health
		health.health = defense_data.health

	_setup_interactable()
	_setup_tile_pos()


var additional_upgrades: Array[DefenseUpgrade] = []


func get_faction() -> Faction.Type:
	## TODO: extend to other types?
	return Faction.Type.HUMAN


func set_upgrades(upgrades: Array[DefenseUpgrade]):
	additional_upgrades = upgrades

func get_all_item_effects() -> Array[ItemEffect]:
	var added_effects = _get_upgrade_effects()
	return defense_data.base_effects + added_effects


func get_runtime_stat(stat_type: DefenseData.BASE_STAT) -> float:
	match stat_type:
		DefenseData.BASE_STAT.HEALTH:
			return defense_data.health + get_total_additive_base_stat_modifier(DefenseData.BASE_STAT.HEALTH)
		DefenseData.BASE_STAT.DAMAGE:
			return defense_data.attack_damage + get_total_additive_base_stat_modifier(DefenseData.BASE_STAT.DAMAGE)
		DefenseData.BASE_STAT.ATTACK_SPEED:
			# TODO: Clamp
			return defense_data.attack_cooldown + get_total_additive_base_stat_modifier(DefenseData.BASE_STAT.ATTACK_SPEED)
		DefenseData.BASE_STAT.PROJECTILE_SPEED:
			return defense_data.projectile_speed
		_:
			push_error("Invalid stat type")
			return 1


func get_defense_type() -> DefenseData.DEFENSE_TYPE:
	return defense_data.defense_type


func get_total_additive_base_stat_modifier(base_stat: DefenseData.BASE_STAT) -> float:
	var modifier: float = 1

	for upgrade in additional_upgrades:
		var upgrade_modifier = upgrade.get_additive_base_stat_modifier(base_stat)

		## TODO add scaling options
		modifier += upgrade_modifier
		
	return modifier


func get_defense_priority() -> PRIORITY:
	return defense_data.defense_priority

## gets the effects that were added by defense upgrades
func _get_upgrade_effects() -> Array[ItemEffect]:
	var added_effects: Array[ItemEffect] = []
	for upgrade: DefenseUpgrade in additional_upgrades:
		for effect: ItemEffect in upgrade:
			added_effects.append(effect)
	return added_effects


func _to_string() -> String:
	var m = str(defense_data)
	m += "\n"

	if additional_upgrades.size() > 0:
		m += "Upgrades :"
	for upgrade in additional_upgrades:
		m += str(upgrade)
		m += "\n"
		
	return m

func _setup_interactable():
	# TODO: Specify interactable radius
	var interactable = Interactable.create_interactable(10)
	# interactable.sprite = main_sprite
	

	var defense_stat_display = defense_stat_display_scene.instantiate() as DefenseStatDisplay
	defense_stat_display.setup(self)
	interactable.context_nodes.append(defense_stat_display)
	
	var pickup_defense = pickup_defense_scene.instantiate() as PickupDefense
	pickup_defense.setup(world, self)
	interactable.context_nodes.append(pickup_defense)
	add_child(interactable)


func _setup_tile_pos():
	var world = get_node("/root/World") as World
	var defense_layer = world.defense_tiles

	var local_pos = defense_layer.to_local(global_position)
	tile_pos = defense_layer.local_to_map(local_pos)
	print(tile_pos)


func _setup_pawn_tracker():
	pawn_tracker = PawnTracker.new()
	pawn_tracker.vision_distance = defense_data.attack_range
	pawn_tracker.factions_to_track = defense_data.factions_to_track
	add_child(pawn_tracker)
