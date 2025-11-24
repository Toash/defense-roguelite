extends Node2D

class_name PlayerCoins

signal coins_changed(new_amount: int)


@export var starting_coins: int
@onready var current_coins: int = starting_coins

# func _ready():
# 	self.current_coins = starting_coins


func has_enough(amount: int):
	return current_coins >= amount


func change_coins(amount: int):
	if amount < 0:
		if not has_enough(abs(amount)):
			return

	current_coins += amount
	coins_changed.emit(current_coins)
