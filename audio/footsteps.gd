extends Node2D


## play footsteps based on footsteps of a character sprite. 
class_name Footsteps

@export var character_sprite: CharacterSprite
@export var bus: String = "footsteps"
@export var volume = 1

func _ready():
	character_sprite.foot_touchdown.connect(_play)
	
func _play():
	AudioManager.play_key(AudioManager.KEY.STEP_GRASS, volume, global_position, bus)