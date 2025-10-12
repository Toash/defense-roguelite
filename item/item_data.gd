extends Resource

# "abstract" class for itemdata
class_name ItemData

@export var id: int

@export var display_name: String
@export var description: String
@export var max_stack: int


@export var icon: Texture2D


# func to_dict() -> Dictionary:
#     return {
#         "id": id,
#         "display_name": id,
#         "id": id,
#     }
