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

	for ingredient in self.blueprint.get_ingredients():
		var item_data = ingredient.item_data
		var amount = ingredient.amount

		var label: Label = Label.new()
		label.text = item_data.display_name + " X " + str(amount)
		ingredients_root.add_child(label)

	for output in self.blueprint.get_outputs():
		var item_data = output.item_data
		var amount = output.amount

		var label: Label = Label.new()
		label.text = item_data.display_name + " X " + str(amount)
		output_root.add_child(label)

func _on_button_pressed():
	blueprint_craft.emit(blueprint)