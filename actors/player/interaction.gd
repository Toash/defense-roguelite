extends Node

## handles interaction for current interactable of a player.
class_name Interaction

@export var player: Node2D
@export var interact_distance = 10000 # TODO change

var nearest_interactable: Interactable

## Gets the container of the nearest interactable, if it has a container
func get_nearest_container_if_it_exists() -> ItemContainer:
	if nearest_interactable != null:
		for child in nearest_interactable.get_parent().get_children():
			if child is ItemContainer:
				return child as ItemContainer
	return null


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if nearest_interactable:
			_interact(nearest_interactable, player)
		

func _interact(interactable: Interactable, player: Node2D):
	var interact_pos: Vector2 = interactable.global_position
	var player_pos: Vector2 = player.global_position

	var distance = (interact_pos - player_pos).length()

	if distance < interact_distance:
		interactable.interact(player)
	else:
		print("Interaction: Player is too far away.")


func _on_nearest_interactable_changed(new_interactable: Interactable):
	if nearest_interactable != null:
		nearest_interactable.hide_outline()

	if new_interactable != null:
		new_interactable.show_outline()

	nearest_interactable = new_interactable
	print("Interaction: Current interactable: " + str(nearest_interactable))
