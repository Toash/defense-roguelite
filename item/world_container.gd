extends Node2D

## corresponds to container in the world

class_name WorldContainer

## uses the path of this when loading. 
@export var packed_scene: PackedScene
@export var container: ItemContainer

func _ready() -> void:
	print(packed_scene)
	if packed_scene == null:
		push_error("World Container: packed_scene should be set for " + str(get_path()))
	if container == null:
		push_error("World Container: container should be set for " + str(get_path()))

func _interact(player: Node2D):
	# var world_container_input: WorldContainerInput = player.get_node_or_null("WorldContainerInput")
	var world_container_input: WorldContainerInput = player.get_world_container_input()
	if world_container_input == null:
		push_error("World Container: could not find the WorldContainerInput on the player!")
	world_container_input.interact_with(container)


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.RELOAD,

		SaveManager.SaveKeys_RELOAD.RESOURCE_PATH: packed_scene.resource_path,
		SaveManager.SaveKeys_RELOAD.PARENT_SCENETREE_PATH: get_parent().get_path(),

		"container": container.get_dict()
	}

func load(dictionary: Dictionary):
	container.load_dict(dictionary.container)
