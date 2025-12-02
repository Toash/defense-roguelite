extends Area2D

## RUNTIME root node for all defenses 
class_name RuntimeDefense

# How do other enemies see this ? 
enum PRIORITY {
	INVISIBLE,
	VISIBLE
}


@export var health: Health


# "on-paper data"
@export var defense_data: DefenseData

@export var applied_upgrades: Array[DefenseUpgrade]

func _ready():
	add_to_group("defenses")

	if defense_data == null:
		push_error("RuntimeDefense: defense data not specified!")

	if health != null:
		health.died.connect(func():
			queue_free()
			)
		health.max_health = defense_data.health
		health.health = defense_data.health


# var upgraded_defense_effects: Array[ItemEffect] = []
var added_upgrades: Array[DefenseUpgrade] = []

# func add_upgrade_item_effect(effect: ItemEffect):
# 	var dup = effect.duplicate()
# 	upgraded_defense_effects.append(dup)

func add_upgrade(upgrade: DefenseUpgrade):
	added_upgrades.append(upgrade)

func get_all_item_effects() -> Array[ItemEffect]:
	var added_effects = _get_added_effects()
	return defense_data.base_effects + added_effects


func get_runtime_stat(stat_type: DefenseData.BASE_STAT) -> float:
	match stat_type:
		DefenseData.BASE_STAT.HEALTH:
			return defense_data.health * _get_base_stat_multiplier(DefenseData.BASE_STAT.HEALTH)
		DefenseData.BASE_STAT.DAMAGE:
			return defense_data.damage * _get_base_stat_multiplier(DefenseData.BASE_STAT.DAMAGE)
		DefenseData.BASE_STAT.ATTACK_SPEED:
			return defense_data.attack_cooldown / _get_base_stat_multiplier(DefenseData.BASE_STAT.ATTACK_SPEED)
		DefenseData.BASE_STAT.PROJECTILE_SPEED:
			return defense_data.projectile_speed
		_:
			push_error("Invalid stat type")
			return 1


func get_defense_type() -> DefenseData.DEFENSE_TYPE:
	return defense_data.defense_type

func get_defense_data() -> DefenseData:
	return self.defense_data


func _get_base_stat_multiplier(base_stat: DefenseData.BASE_STAT):
	var mult: float = 1

	for upgrade in added_upgrades:
		var upgrade_mult = upgrade.get_base_stat_multiplier(base_stat)

		## TODO add scaling options
		mult += upgrade_mult
		
	return mult

func _get_added_effects() -> Array[ItemEffect]:
	var added_effects: Array[ItemEffect] = []
	for upgrade: DefenseUpgrade in applied_upgrades:
		for effect: ItemEffect in upgrade:
			added_effects.append(effect)
	return added_effects


func _to_string() -> String:
	var m = str(defense_data)
	m += "\n"

	for upgrade in added_upgrades:
		m += str(upgrade)
		m += "\n"
		
	return m