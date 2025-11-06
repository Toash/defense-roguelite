extends Node


class_name Interaction

@export var interact_distance = 100

var current_interactable: Interactable


func interact(interactable: Interactable, player: Node2D):
	var interact_pos: Vector2 = interactable.global_position
	var player_pos: Vector2 = player.global_position

	var distance = interact_pos - player_pos

	if distance < interact_distance:
		interactable.interact()


func _on_nearest_interactable_changed(new_interactable: Interactable):
	if current_interactable != null:
		current_interactable.hide_outline()
		
	if new_interactable != null:
		new_interactable.show_outline()

	current_interactable = new_interactable
