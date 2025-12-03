extends Node2D


## runtime manager for upgrades
class_name UpgradeManager

signal upgrade_applied(upgrade: Upgrade)


@export var upgrade_pool: Array[Upgrade] = []

# var _defense_type_to_upgrades :Dictionary[DefenseData.DEFENSE_TYPE,Array[DefenseUpgrade]] 
## defense upgrades the player has.
var _defense_type_to_upgrades = {}

# @export var upgrades: 

var defense_manager: DefenseManager


func _ready() -> void:
	_load_upgrade_data("res://upgrades/resources")
	defense_manager = (get_node("/root/World/GameState") as GameState).defense_manager
	if defense_manager == null:
		push_error("UpgradeManager: Could not find defense manager!")

	for d_type in DefenseData.DEFENSE_TYPE.keys():
		_defense_type_to_upgrades[d_type] = []


func get_all() -> Array[Upgrade]:
	return upgrade_pool

func get_by_id(id: int) -> Upgrade:
	for upgrade in upgrade_pool:
		if upgrade.id == id:
			return upgrade
	push_error("Could not find upgrade")
	return null

# func get_defense_upgrades_from_item_data(item_data: ItemData) -> Array[DefenseUpgrade]:
# 	var d_types = item_data.get_defense_types()
# 	var d_upgrades: Array[DefenseUpgrade] = []
# 	for d_type in d_types:
# 		if d_type in _defense_type_to_upgrades:
# 			d_upgrades += _defense_type_to_upgrades[d_type]
# 	return d_upgrades


func get_registered_data() -> Array[DefenseData]:
	var ret = []
	var defenses = get_tree().get_nodes_in_group("defenses")
	for defense: RuntimeDefense in defenses:
		ret.append(defense.defense_data)
	return ret

## sets the upgrades that the player has on the defense.
func sync_defense_upgrades(defense: RuntimeDefense):
	var d_type = defense.defense_data.defense_type
	var upgrades: Array[DefenseUpgrade] = _defense_type_to_upgrades.get(d_type, [])
	defense.set_upgrades([])


func acquire_upgrade(upgrade: Upgrade):
	if upgrade is DefenseUpgrade:
		for d_type in upgrade.applies_to:
			_defense_type_to_upgrades[d_type].append(upgrade)

		# sync runtime defenses
		for defense: RuntimeDefense in defense_manager.get_defenses():
			sync_defense_upgrades(defense)

	print("Acquired upgade: " + upgrade.name)
	Console.log_message("Acquired upgade: " + upgrade.name)
	upgrade_applied.emit(upgrade)

func acquire_upgrade_by_id(id: int):
	print("acxquire")
	var upgrade: Upgrade = get_by_id(id)
	acquire_upgrade(upgrade)


func _load_upgrade_data(path: String) -> void:
	var id_count: int = 0
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			# if file_name != "." and file_name != "..":
			_load_upgrade_data("%s/%s" % [path, file_name])
		elif file_name.ends_with(".tres"):
			var data: Upgrade = load("%s/%s" % [path, file_name])
			data.id = id_count
			id_count += 1
			if data:
				upgrade_pool.append(data)

		file_name = dir.get_next()
	
	dir.list_dir_end()
