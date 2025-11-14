extends Node2D

class_name HurtSound


@export var health: Health
@export var audio_key: AudioManager.KEY
@export var bus: String = "master"


func _ready():
	health.health_changed.connect(_on_health_changed)


func _on_health_changed(new_val: int):
	AudioManager.play_key(audio_key, 1, global_position, bus)
