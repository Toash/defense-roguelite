@abstract
## base class that defines what happens what items "do stuff"
class_name ItemEffect

extends Resource


@export var effect_name: String
@export var description: String
# func apply(user: Node2D, ctx: Dictionary):
#     push_error("Implement apply for the item effect")

## called when the effect is triggered.
@abstract func apply(context: ItemContext)
