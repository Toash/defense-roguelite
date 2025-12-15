extends Control


class_name CraftingUI

signal blueprint_craft(blueprint: Blueprint)

@export var blueprint_scene: PackedScene
@export var blueprints_root: Control


var blueprints: Array[Blueprint]


func update(blueprints: Array[Blueprint]):
	self.blueprints = blueprints

	for blueprint in blueprints:
		var scene: BlueprintUI = blueprint_scene.instantiate()
		scene.setup(blueprint)
		scene.blueprint_craft.connect(_on_blueprint_pressed)
		blueprints_root.add_child(scene)


func _on_blueprint_pressed(blueprint: Blueprint):
	blueprint_craft.emit(blueprint)