extends Node

## emits signal when interacting with world containers
class_name WorldContainerInput

signal container_interacted(container: ItemContainer)
signal container_changed(container: ItemContainer)


func interact_with(container: ItemContainer):
	container_interacted.emit(container)

func interactable_changed(interactable: Interactable):
	# check if it has ItemContainer
	if interactable != null:
		for child in interactable.get_parent().get_children():
			if child is ItemContainer:
				container_changed.emit(child as ItemContainer)
				return

		container_changed.emit(null)
	else:
		container_changed.emit(null)


# func clear_container(_interactable: Interactable):
# 	container_interacted.emit(null)
