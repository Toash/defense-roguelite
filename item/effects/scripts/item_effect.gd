@abstract
class_name ItemEffect

extends Resource


# func apply(user: Node2D, ctx: Dictionary):
#     push_error("Implement apply for the item effect")

@abstract func apply(context: ItemContext)