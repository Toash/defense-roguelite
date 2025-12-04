extends PanelContainer

class_name UpgradesUI


@export var upgrades_scene: PackedScene
@export var upgrades_root: HBoxContainer

var upgrade_manager: UpgradeManager


func _ready():
	hide()
	var game_state = (get_node("/root/World/GameState") as GameState)
	if game_state != null:
		upgrade_manager = game_state.upgrade_manager
		if upgrade_manager == null:
			push_error("UpgradesUI: could not find upgrade manager!")
		upgrade_manager.got_an_upgrade_hmm_should_i_take_it.connect(_on_got_upgrade)
	else:
		push_error("UpgradesUI: could not find game state!")


func show():
	visible = true
	get_tree().paused = true

func hide():
	visible = false
	get_tree().paused = false


func _add_upgrade_display(upgrade: Upgrade):
	var upgrade_ui: UpgradeUI = upgrades_scene.instantiate() as UpgradeUI

	if upgrade_ui == null:
		push_error("Upgrade scene should be of type upgrade ui!")

	upgrade_ui.setup(upgrade)
	upgrade_ui.pressed_upgrade.connect(func(upgrade: Upgrade):
		self.upgrade_manager.acquire_upgrade(upgrade)
		_clear_displayed_upgrades()
		hide()
		)
	upgrades_root.add_child(upgrade_ui)


func _clear_displayed_upgrades():
	for upgrade in upgrades_root.get_children():
		upgrade.queue_free()

	
func _on_got_upgrade(upgrade: Upgrade):
	_add_upgrade_display(upgrade)
	show()
