extends Node


class_name Interaction

@export var player: Node2D
@export var interact_distance = 10000 # TODO change

var current_interactable: Interactable


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_interact(current_interactable, player)
		

func _interact(interactable: Interactable, player: Node2D):
	var interact_pos: Vector2 = interactable.global_position
	var player_pos: Vector2 = player.global_position

	var distance = (interact_pos - player_pos).length()

	if distance < interact_distance:
		interactable.interact(player)
	else:
		print("Interaction: Player is too far away.")


func _on_nearest_interactable_changed(new_interactable: Interactable):
	if current_interactable != null:
		current_interactable.hide_outline()

	if new_interactable != null:
		new_interactable.show_outline()

	current_interactable = new_interactable
	print("Interaction: Current interactable: " + str(current_interactable))
