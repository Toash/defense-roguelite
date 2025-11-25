extends Area2D

class_name Defense

# How do other enemies see this ? 
enum PRIORITY {
	INVISIBLE,
	VISIBLE

}


@export var health: Health
@export var defense_data: DefenseData


func _ready():
	if health != null:
		health.died.connect(func():
			queue_free()
			)


func get_data() -> DefenseData:
	return self.defense_data
