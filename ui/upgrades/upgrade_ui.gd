extends Control

class_name UpgradeUI

@export var upgrade: DefenseUpgrade


@export_group("scene references")
@export var upgrade_name: Label
@export var description: Label
@export var icon: TextureRect
@export var applies_to: Label
@export var button: Button


func _ready():
	if upgrade != null:
		setup(upgrade)

func setup(upgrade: DefenseUpgrade):
	self.upgrade = upgrade
	upgrade_name.text = upgrade.name
	description.text = upgrade.description
	icon.texture = upgrade.icon

	applies_to.text = "Applies to: "
	var i: int = 0
	for defense_type in upgrade.applies_to:
		applies_to.text += DefenseData.DEFENSE_TYPE.keys()[defense_type]
		if i == upgrade.applies_to.size() - 1:
			applies_to.text += ", "
		i += 1


	button.pressed.connect(func():
		print("Pressed upgrade " + upgrade_name.text)
		)
