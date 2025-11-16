extends Control


class_name CraftingUI

@export var blueprint_scene: PackedScene
@export var blueprints_root: Control


var blueprints: Array[Blueprint]


func setup(blueprints: Array[Blueprint]):
	self.blueprints = blueprints

	for blueprint in blueprints:
		var scene: BlueprintUI = blueprint_scene.instantiate()
		scene.setup(blueprint)

		blueprints_root.add_child(scene)
