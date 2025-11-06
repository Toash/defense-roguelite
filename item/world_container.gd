extends Node2D

## corresponds to container in the world

class_name WorldContainer

## uses the path of this when loading. 
@export var scene: PackedScene
@export var container: ItemContainer

func _ready() -> void:
    if scene == null:
        push_error("World Container: scene should be set.")
    if container == null:
        push_error("World Container: container should be set.")

func _interact(player: Node2D):
    var world_container_input: WorldContainerInput = player.get_node_or_null("WorldContainerInput")
    if world_container_input == null:
        push_error("World Container: could not find the WorldContainerInput on the player!")
    world_container_input.interact_with(container)


func save() -> Dictionary:
    return {
        "save_type": SaveManager.SaveType.RELOAD,

        SaveManager.SaveKeys_RELOAD.RESOURCE_PATH: scene.resource_path,
        SaveManager.SaveKeys_RELOAD.PARENT_SCENETREE_PATH: get_parent().get_path(),

        "container": container.get_dict()
    }

func load(dictionary: Dictionary):
    container.load_dict(dictionary.container)
