extends Area2D


## spread throughout the world. Just obstructs things from view.
class_name Fog


@export var anim_player: AnimationPlayer
var disappearing = false

# inefficeint?
func _process(delta):
	if disappearing:
		if not anim_player.is_playing():
			queue_free()

func dissipate():
	anim_player.current_animation = "dissipate"
	anim_player.play()
	disappearing = true
