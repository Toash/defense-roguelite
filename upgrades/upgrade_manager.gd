extends Node2D


## runtime manager for upgrades
class_name UpgradeManager

signal got_an_upgrade_hmm_should_i_take_it(upgrade: Upgrade)


@export var player: Player
@export var upgrade_pool: Array[Upgrade] = []

# Dictionary[DefenseData.DEFENSE_TYPE,Array[DefenseUpgrade]] 


## defense upgrades corresponding to defense types
var _all_defense_type_to_upgrades: Dictionary[DefenseData.DEFENSE_TYPE, Array] = {}

# @export var upgrades: 

var defense_manager: DefenseManager


func _ready() -> void:
	for d_type in DefenseData.DEFENSE_TYPE.values():
		_all_defense_type_to_upgrades[d_type] = []
	_load_upgrade_data("res://upgrades/resources")
	defense_manager = (get_node("/root/World/GameState") as GameState).defense_manager
	if defense_manager == null:
		push_error("UpgradeManager: Could not find defense manager!")


func get_all() -> Array[Upgrade]:
	return upgrade_pool


func get_by_id(id: int) -> Upgrade:
	for upgrade in upgrade_pool:
		if upgrade.id == id:
			got_an_upgrade_hmm_should_i_take_it.emit(upgrade)
			return upgrade
	push_error("Could not find upgrade")
	return null

func propose_random_upgrades(amount: int) -> Array[Upgrade]:
	var upgrades: Array[Upgrade]
	for i in range(amount):
		upgrades.append(propose_random_upgrade())
	return upgrades

func propose_random_upgrade() -> Upgrade:
	# var random_type: DefenseData.DEFENSE_TYPE = DefenseData.get_random_defense_type()
	# var random_type: DefenseData.DEFENSE_TYPE = player.player_defenses.get_random_player_owned_defense_type()
	var valid_defense_upgrades: Array = _get_valid_defense_upgrades()

	if valid_defense_upgrades.size() == 0:
		Console.log_message("Upgrade Manager: Could not get random upgrade, player does not have defenses.")
		return

	var upgrade = valid_defense_upgrades[randi() % valid_defense_upgrades.size()] as DefenseUpgrade
	got_an_upgrade_hmm_should_i_take_it.emit(upgrade)

	return upgrade


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
			var upgrade: Upgrade = load("%s/%s" % [path, file_name])
			upgrade.id = id_count
			id_count += 1
			if upgrade:
				upgrade_pool.append(upgrade)
				if upgrade is DefenseUpgrade:
					for d_type: DefenseData.DEFENSE_TYPE in upgrade.applies_to:
						_all_defense_type_to_upgrades[d_type].append(upgrade)

		file_name = dir.get_next()
	
	dir.list_dir_end()


## gets the intersection of the defense upgrades that the player has, as well as the defense upgrades that are present in the game. 
func _get_valid_defense_upgrades() -> Array:
	var player_owned_defense_types: Array[DefenseData.DEFENSE_TYPE] = player.player_defenses.get_player_owned_defense_types()

	var valid_upgrades = []

	for d_type: DefenseData.DEFENSE_TYPE in player_owned_defense_types:
		var d_types: Array = _all_defense_type_to_upgrades.get(d_type)
		if d_types != null:
			valid_upgrades += d_types


	if valid_upgrades.size() > 0:
		return valid_upgrades
	else:
		return []


# func get_defense_upgrades_from_item_data(item_data: ItemData) -> Array[DefenseUpgrade]:
# 	var d_types = item_data.get_defense_types()
# 	var d_upgrades: Array[DefenseUpgrade] = []
# 	for d_type in d_types:
# 		if d_type in _player_defense_type_to_upgrades:
# 			d_upgrades += _player_defense_type_to_upgrades[d_type]
# 	return d_upgrades
# func get_registered_data() -> Array[DefenseData]:
# 	var ret = []
# 	var defenses = get_tree().get_nodes_in_group("defenses")
# 	for defense: RuntimeDefense in defenses:
# 		ret.append(defense.defense_data)
# 	return ret
