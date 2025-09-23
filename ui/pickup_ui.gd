extends Control

var player
var pickups: Array[ItemDrop]
var detector: PickupDetector

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	for node in player.get_children():
		if node is PickupDetector:
			detector = node as PickupDetector

	if detector == null:
		push_error("Player needs pickup detector.")


func _process(delta):
	print(detector.nearby_items)
