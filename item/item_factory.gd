extends Node

@export var pickup_scene: PackedScene = preload("res://item/item_drop.tscn")

func spawn_pickup(data_path: String, qty := 1, pos := Vector2.ZERO) -> Node2D:
    print("ItemFactory: Spawning " + data_path)
    var data: ItemData = load(data_path)
    if data == null:
        push_error("Could not find item data in Item Factory.")
        return null
    
    var inst := ItemInstance.new(data, qty)
    var pickup: ItemDrop = pickup_scene.instantiate()
    pickup.instance = inst
    pickup.global_position = pos
    get_tree().current_scene.add_child.call_deferred(pickup)
    return pickup
