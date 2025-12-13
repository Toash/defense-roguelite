extends Resource

class_name StatusEffect


enum TYPE {
	FIRE,
}
var id: int
@export var name: String
@export var description: String
@export var type: StatusEffect.TYPE
@export var icon: Texture2D
@export var packed_scene: PackedScene
@export var data: StatusEffectData


func _to_string() -> String:
	return "Status Effect: " + name
