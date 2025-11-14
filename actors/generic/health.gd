extends Node


## ensure that this is a direct child of the main node and not renamed. 
## ( lots of components are checking if this a direct child.)
class_name Health

signal died
signal health_changed(new_value)


@export var max_health: int = 100
@onready var health: int = max_health


func to_dict() -> Dictionary:
	return {
		"health": self.health,
		"max_health": self.max_health
	}

func from_dict(dict: Dictionary) -> void:
	self.health = dict.health
	self.max_health = dict.max_health


func damage(amount: int):
	print("damage!!")
	if health <= 0: return

	health = clamp(health - amount, 0, max_health)

	health_changed.emit(health)

	if health <= 0:
		died.emit()


func heal(amount: float):
	if health <= 0: return

	health = clamp(health + amount, 0, max_health)
	health_changed.emit(health)