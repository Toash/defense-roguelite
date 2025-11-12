extends Node2D

## corresponds to container in the world

class_name WorldContainer

## uses the path of this when loading. 
@export var self_resource_path: String
@export var container: ItemContainer
@export var interactable: Interactable

func _ready() -> void:
	if not self_resource_path:
		push_error("World Container: self resource path should be defined")
	if container == null:
		push_error("World Container: container should be set for " + str(get_path()))

	interactable.interacted.connect(_interact)

func _interact(player: Node2D):
	# var world_container_input: WorldContainerInput = player.get_node_or_null("WorldContainerInput")
	var world_container_input: WorldContainerInput = player.get_world_container_input()
	if world_container_input == null:
		push_error("World Container: could not find the WorldContainerInput on the player!")
	world_container_input.interact_with(container)


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.RELOAD,

		SaveManager.SaveKeys_RELOAD.RESOURCE_PATH: self_resource_path,
		SaveManager.SaveKeys_RELOAD.PARENT_SCENETREE_PATH: get_parent().get_path(),

		"container": container.get_dict()
	}

func load(dictionary: Dictionary):
	container.load_dict(dictionary.container)
