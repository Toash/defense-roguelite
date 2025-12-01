extends Node2D

## runtime manager for upgrades
class_name UpgradeManager


var acquired_upgrades: Array[DefenseUpgrade] = []


# @export var upgrades: 

var defense_manager: DefenseManager


func _ready() -> void:
	defense_manager = (get_node("/root/World/GameState") as GameState).defense_manager


func get_registered_data() -> Array[DefenseData]:
	var ret = []
	var defenses = get_tree().get_nodes_in_group("defenses")
	for defense: Defense in defenses:
		ret.append(defense.defense_data)
	return ret


func apply_upgrade_to_compatible_towers(upgrade: DefenseUpgrade):
	for defense: Defense in defense_manager.get_defenses():
		if defense.has_allowed_upgrade(upgrade):
			defense.add_upgrade(upgrade)

	acquired_upgrades.append(upgrade)
