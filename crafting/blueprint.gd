extends Resource

class_name Blueprint


@export var coins_needed: int
@export var ingredients: Array[ItemDataGroup]
@export var outputs: Array[ItemDataGroup]


func get_ingredients() -> Array[ItemDataGroup]:
	return ingredients

func get_outputs() -> Array[ItemDataGroup]:
	return outputs

func get_defense_type_outputs() -> Array[DefenseData.DEFENSE_TYPE]:
	var ret: Array[DefenseData.DEFENSE_TYPE] = []
	for output in outputs:
		var item: ItemData = output.item_data
		var defense_types: Array[DefenseData.DEFENSE_TYPE] = item.get_defense_types()
		ret += defense_types
		
	return ret