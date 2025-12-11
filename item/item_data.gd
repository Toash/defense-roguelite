extends Resource

# "abstract" class for itemdata
class_name ItemData

# @export var id: int
var id: int

@export_group("Inventory")
@export var display_name: String
@export var description: String
@export var max_stack: int
@export var icon: Texture2D

@export_group("Usage")
@export var cooldown_time: float = 1
@export var consume_on_use := false


@export_group("Ground Display")
@export var ground_scale: float = 1


@export_group("In-Game Display")
# ingame display 
@export var ingame_sprite: Texture2D
@export var equipped_scale: float = 1
@export var sprite_flipped = false

## item should point towards the target.
@export var follow_target = true


## TODO: deprecate this - sounds should only be spawned in effects
# @export_group("Sound")
# @export var use_sound_key: AudioManager.KEY = AudioManager.KEY.NO_SOUND
# @export var use_sound_bus: String = "master"


@export_group("Functionality")
# functionality
@export var item_effects: Array[ItemEffect]


## returns whether it was successful or not.
func apply_effects(context: ItemContext) -> bool:
	for effect in item_effects:
		var result = effect.apply(context)
		if result == false:
			return false

	return true


func has_build_effect() -> bool:
	for effect in item_effects:
		if effect is BuildEffect:
			return true
	return false

func get_first_build_effect() -> BuildEffect:
	for effect in item_effects:
		if effect is BuildEffect:
			return effect
	return null
