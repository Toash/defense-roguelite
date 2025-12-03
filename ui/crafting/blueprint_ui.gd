extends PanelContainer


class_name BlueprintUI

signal blueprint_craft(blueprint: Blueprint)

@export var ingredients_root: Control
@export var output_root: Control
@export var button: Button

var blueprint: Blueprint
func _ready():
	button.pressed.connect(_on_button_pressed)


func setup(blueprint: Blueprint):
	self.blueprint = blueprint


	if blueprint.coins_needed > 0:
		var label: Label = Label.new()
		label.text = str(blueprint.coins_needed) + " Coins"
		ingredients_root.add_child(label)

	for ingredient in self.blueprint.get_ingredients():
		var item_data = ingredient.item_data
		var amount = ingredient.amount

		var label: Label = Label.new()
		label.text = item_data.display_name + " X " + str(amount)
		ingredients_root.add_child(label)

	for output in self.blueprint.get_outputs():
		var item_data: ItemData = output.item_data
		var amount = output.amount

		var hbox: HBoxContainer = HBoxContainer.new()
		var icon: TextureRect = TextureRect.new()
		icon.texture = item_data.icon

		var label: Label = Label.new()
		label.text = item_data.display_name + " X " + str(amount)

		# hbox.add_child(icon)
		hbox.add_child(label)

		# output_root.add_child(label)
		output_root.add_child(hbox)

func _on_button_pressed():
	blueprint_craft.emit(blueprint)