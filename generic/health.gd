extends Node


class_name Health

signal died
signal health_changed(new_value)


@export var max_health: int = 100
var health: int = max_health


func damage(amount: int):
	if health <= 0: return

	health = clamp(health - amount, 0, max_health)

	health_changed.emit(health)

	if health <= 0:
		died.emit()


func heal(amount: float):
	if health <= 0: return

	health = clamp(health + amount, 0, max_health)
	health_changed.emit(health)