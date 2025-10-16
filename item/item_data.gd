extends Resource

# "abstract" class for itemdata
class_name ItemData

@export var id: int

@export var display_name: String
@export var description: String
@export var max_stack: int

@export var consume_on_use := false

@export var icon: Texture2D


# functionality
@export var item_effects: Array[ItemEffect]


# this is stateless
# since item data will be a shared resource
func apply_effects(user, ctx):
    for effect in item_effects:
        effect.apply(user, ctx)
