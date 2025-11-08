extends AudioStreamPlayer2D


## play footsteps based on footsteps of a character sprite. 
class_name Footsteps

@export var character_sprite: CharacterSprite
@export var clips: Array[AudioStream]


var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _get_random_clip() -> AudioStream:
	var i: int = rng.randi_range(0, clips.size() - 1)
	return clips[i]

func _ready():
	character_sprite.foot_touchdown.connect(_play)
	if clips.size() == 0:
		push_error("Footsteps: audio clips not provided!")
	
func _play():
	stream = _get_random_clip()
	play()
