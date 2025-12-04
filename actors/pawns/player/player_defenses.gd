extends Node2D


## node for player owned defenses
class_name PlayerDefenses

signal upgrade_acquired(upgrade: Upgrade)


@export var player_crafting: PlayerCrafting

# TODO put this on the player
var _player_defense_type_to_upgrades: Dictionary[DefenseData.DEFENSE_TYPE, Array] = {}

func _ready() -> void:
	for d_type in DefenseData.DEFENSE_TYPE.values():
		_player_defense_type_to_upgrades[d_type] = []


func get_player_owned_defense_types() -> Array[DefenseData.DEFENSE_TYPE]:
	var ret: Array[DefenseData.DEFENSE_TYPE] = []
	for blueprint in player_crafting.get_blueprints():
		var defense_types: Array[DefenseData.DEFENSE_TYPE] = blueprint.get_defense_type_outputs()
		ret += defense_types
	print(ret)
	return ret

## sets the upgrades that the player has on the defense.
func sync_defense_upgrades(defense: RuntimeDefense):
	var d_type = defense.defense_data.defense_type
	var upgrades := _player_defense_type_to_upgrades.get(d_type, [])
	var defense_upgrades: Array[DefenseUpgrade] = []
	for index in upgrades:
		var upgrade: DefenseUpgrade = upgrades[index] as DefenseUpgrade
		defense_upgrades.append(upgrade)

		
	defense.set_upgrades(defense_upgrades)


func acquire_upgrade(upgrade: Upgrade):
	if upgrade is DefenseUpgrade:
		for d_type in upgrade.applies_to:
			_player_defense_type_to_upgrades[d_type].append(upgrade)


		var defense_manager = (get_node("/root/World/GameState") as GameState).defense_manager
		if defense_manager == null:
			push_error("Player Defenses: Defense manager is null!")
		# sync runtime defenses
		for defense: RuntimeDefense in defense_manager.get_defenses():
			sync_defense_upgrades(defense)


	var message = "Acquired upgade: " + upgrade.name
	print(message)
	Console.log_message(message)
	TextPopupManager.popup(message, get_viewport_rect().size / 2)
	upgrade_acquired.emit(upgrade)
