extends Node2D

## in world interactable that can be is_open and closed by other actors.
class_name Door

@export var interactable: Interactable

@export_group("Collision")
@export var collider: StaticBody2D
@export var collision_layer: int

@export_group("Visuals")
@export var sprite: Sprite2D
@export var door_open: Texture2D
@export var door_close: Texture2D


@export_group("Audio")
@export var open_sound_key: AudioManager.KEY
@export var close_sound_key: AudioManager.KEY

var is_open: bool = false

func _ready():
	interactable.interacted.connect(_interact)
	_set_open(false, true)

func _set_open(open: bool, silent = false):
	self.is_open = open
	if open:
		sprite.texture = door_open
		collider.set_collision_layer_value(collision_layer, false)
		if not silent:
			AudioManager.play_key(open_sound_key, global_position)

	else:
		sprite.texture = door_close
		collider.set_collision_layer_value(collision_layer, true)
		if not silent:
			AudioManager.play_key(close_sound_key, global_position)

func _interact(player: Node2D):
	_set_open(!is_open)
	pass