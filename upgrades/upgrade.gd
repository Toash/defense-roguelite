extends Resource

class_name Upgrade


var id: int

@export_group("Core")
@export var name: String
@export var description: String
@export var icon: Texture2D

func _to_string() -> String:
    return "Upgrade Name : " + name + " ID: " + str(id)