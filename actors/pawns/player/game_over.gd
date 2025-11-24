extends Node2D

## handles loss state
class_name GameOver

signal game_over

@export var player: Player
@export var nexus: Nexus


func _ready():
	player.health.died.connect(_game_over)
	nexus.health.died.connect(_game_over)


func _game_over():
	game_over.emit()
	player.dead = true
	pass
