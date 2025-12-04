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


# this is stateless
# since item data will be a shared resource
func apply_effects(context: ItemContext):
	for effect in item_effects:
		effect.apply(context)


func has_build_effect() -> bool:
	for effect in item_effects:
		if effect is BuildEffect:
			return true
	return false


## returns the corresponding defense types if the item can build defenses.
func get_defense_types() -> Array[DefenseData.DEFENSE_TYPE]:
	var ret: Array[DefenseData.DEFENSE_TYPE] = []
	for effect in item_effects:
		if effect is BuildDefenseEffect:
			ret.append(effect.defense_type)
	return ret
