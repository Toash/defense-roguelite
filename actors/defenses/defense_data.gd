extends Resource

## Static initial / base data for defenses
class_name DefenseData

enum DEFENSE_TYPE {
	RANGED
}

enum BASE_STAT {
	HEALTH,
	DAMAGE,
	ATTACK_SPEED,
	PROJECTILE_SPEED,
}


@export_group("General")
## the item data that this defense is linked to. 
@export var item_data: ItemData

## used for referring to defends that perform similar functions. 
@export var defense_type: DEFENSE_TYPE

## used for determining what type of enemies can target this defense.
@export var defense_priority: RuntimeDefense.PRIORITY


@export_group("Base stats")
@export var health: int = 100
@export var attack_range: float = 450
@export var attack_damage: int = 10
@export var attack_cooldown: float = 2

@export_group("Behavior")
## TODO: Just make this runtime - this should depend on who placed the defense.
@export var factions_to_track: Array[Faction.Type] = [Faction.Type.ENEMY]
## The base functionality of this tower
@export var base_effects: Array[ItemEffect] = []

# @export_group("Upgrades")
# ## upgrades that are able to be applied on this tower.
# @export var allowed_upgrades: Array[DefenseUpgrade]

@export_group("Projectiles")
@export var projectile_speed: float = 600


func get_defense_name() -> String:
	print("item data" + str(item_data))
	var item_name := self.item_data.display_name
	if item_name.is_empty():
		push_error("Item Display name is empty!")
	return item_name


func get_base_stat(base_stat: BASE_STAT) -> float:
	match base_stat:
		BASE_STAT.HEALTH:
			return health
		BASE_STAT.DAMAGE:
			return attack_damage
		BASE_STAT.ATTACK_SPEED:
			return attack_cooldown
		BASE_STAT.PROJECTILE_SPEED:
			return projectile_speed
		_:
			push_error("base_stat not specified")
			return 0

func _to_string() -> String:
	return "Tower: " + str(DEFENSE_TYPE.keys()[defense_type])


static func get_default() -> DefenseData:
	return DefenseData.new()

static func defense_type_to_string(stat: int) -> String:
	var raw: String = DEFENSE_TYPE.keys()[stat]
	var parts := raw.to_lower().split("_")
	for i in parts.size():
		parts[i] = parts[i].capitalize()
	return " ".join(parts)

static func base_stat_to_string(stat: int) -> String:
	var raw: String = BASE_STAT.keys()[stat]
	var parts := raw.to_lower().split("_")
	for i in parts.size():
		parts[i] = parts[i].capitalize()
	return " ".join(parts)
