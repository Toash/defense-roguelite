extends Node2D

# displays an item instance
class_name ItemEquipDisplay


@export var follow_target: bool = false

@onready var sprite: Sprite2D = Sprite2D.new()
var inst: ItemInstance

var target: Vector2

## sets instance to display
## null to hide.
func set_instance(inst: ItemInstance):
    if inst:
        print(inst.data.display_name)
        sprite.texture = inst.data.ingame_sprite as Texture2D
        sprite.visible = true
    else:
        sprite.texture = null
        sprite.visible = false

func _ready():
    add_child(sprite)
    sprite.position = position


func _process(delta):
    if not follow_target: return
    sprite.look_at(target)

func _update_target(pos: Vector2):
    target = pos

func _on_equipment_changed(inst: ItemInstance) -> void:
    set_instance(inst)
