extends Node2D

## runtime manager for upgrades
class_name UpgradeManager


## upgrades that the player can potentially draw from
@export var upgrade_pool: Array[DefenseUpgrade] = []

# var defense_type_to_upgrades :Dictionary[DefenseData.DEFENSE_TYPE,Array[DefenseUpgrade]] 
var defense_type_to_upgrades = {}

# @export var upgrades: 

var defense_manager: DefenseManager


func _ready() -> void:
	defense_manager = (get_node("/root/World/GameState") as GameState).defense_manager

	for d_type in DefenseData.DEFENSE_TYPE.keys():
		defense_type_to_upgrades[d_type] = []


func get_defense_upgrades_from_item_data(item_data: ItemData) -> Array[DefenseUpgrade]:
	var d_types = item_data.get_defense_types()
	var d_upgrades: Array[DefenseUpgrade] = []
	for d_type in d_types:
		if d_type in defense_type_to_upgrades:
			d_upgrades += defense_type_to_upgrades[d_type]


	return d_upgrades

	
func get_registered_data() -> Array[DefenseData]:
	var ret = []
	var defenses = get_tree().get_nodes_in_group("defenses")
	for defense: RuntimeDefense in defenses:
		ret.append(defense.defense_data)
	return ret


func acquire_upgrade(upgrade: DefenseUpgrade):
	# upgrade runtime defenses
	for defense: RuntimeDefense in defense_manager.get_defenses():
		defense.add_upgrade(upgrade)

	for d_type in upgrade.applies_to:
		defense_type_to_upgrades[d_type].append(upgrade)

	# upgrade_pool.append(upgrade)


func get_random_upgrade() -> DefenseUpgrade:
	return upgrade_pool[randi() % upgrade_pool.size()]
