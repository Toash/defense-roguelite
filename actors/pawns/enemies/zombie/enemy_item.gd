extends ItemInstanceProvider


class_name EnemyItem

# @export var inst: ItemInstance
@export var data: ItemData

@onready var inst = ItemInstance.new(data, 1)

func _ready():
    instance_changed.emit(inst)

func _process(delta):
    inst.update_state(delta)

func get_inst() -> ItemInstance:
    return inst
