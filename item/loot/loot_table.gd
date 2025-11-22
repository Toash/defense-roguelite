extends Resource
class_name LootTable

@export var loot_probabilities: Dictionary[ItemDataGroup, float]


func get_drop() -> ItemDataGroup:
	var _rng := RandomNumberGenerator.new()
	if loot_probabilities.is_empty():
		return null

	var total_weight := 0.0
	for item_group in loot_probabilities.keys():
		total_weight += float(loot_probabilities[item_group])

	if total_weight <= 0.0:
		return null

	var r := _rng.randf_range(0.0, total_weight)
	var running := 0.0

	for item_group in loot_probabilities.keys():
		running += float(loot_probabilities[item_group])
		if r <= running:
			return item_group

	push_error("Loot table error")
	return null
