extends Node2D

class_name HealthSound


@export var health: Health
@export var hit: AudioManager.KEY
@export var death: AudioManager.KEY
@export var bus: String = "master"


func _ready():
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)


func _on_health_changed(new_val: int):
	AudioManager.play_key(hit, 1, global_position, bus)

func _on_died():
	AudioManager.play_key(death, 1, global_position, bus)
