extends Resource

class_name Blueprint


@export var coins_needed: int
@export var ingredients: Array[ItemDataGroup]
@export var outputs: Array[ItemDataGroup]


func get_ingredients() -> Array[ItemDataGroup]:
	return ingredients

func get_outputs() -> Array[ItemDataGroup]:
	return outputs
