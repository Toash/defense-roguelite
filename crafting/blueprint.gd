extends Resource

class_name Blueprint


@export var ingredients: Array[ItemDataGroup]
@export var outputs: Array[ItemDataGroup]


func get_ingredients() -> Array[ItemDataGroup]:
	return ingredients

func get_outputs() -> Array[ItemDataGroup]:
	return outputs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
