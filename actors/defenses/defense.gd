extends Area2D

class_name Defense

# How do other enemies see this ? 
enum PRIORITY {
	INVISIBLE,
	VISIBLE

}


@export var defense_data: DefenseData


func get_data() -> DefenseData:
	return self.defense_data