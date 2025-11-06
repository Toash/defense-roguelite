extends Node

## emits signal when interacting with world containers
class_name WorldContainerInput

signal container_interacted(container: ItemContainer)


func interact_with(container: ItemContainer):
	container_interacted.emit(container)


## should be called when the nearest interactable gets changed.
func clear_container(_interactable: Interactable):
	container_interacted.emit(null)
