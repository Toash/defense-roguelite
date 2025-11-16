extends PanelContainer


class_name BlueprintUI


@export var ingredients_root: Control
@export var output_root: Control

var blueprint: Blueprint


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