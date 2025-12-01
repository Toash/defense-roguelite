extends Node2D

## contains information about the current upgrades that the player has
class_name RunUpgrades


var acquired_upgrades: Array[DefenseUpgrade] = []


# @export var upgrades: 


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.keycode == KEY_H:
            print(get_defenses())

func get_registered_data() -> Array[DefenseData]:
    var ret = []
    var defenses = get_tree().get_nodes_in_group("defenses")
    for defense: Defense in defenses:
        ret.append(defense.defense_data)
    return ret


func upgrade_tower(upgrade: DefenseUpgrade):
    for defense in get_defenses():
        # apply upgrade
        pass


    acquired_upgrades.append(upgrade)


func get_defenses() -> Array[Defense]:
    var group: Array[Defense] = []
    for defense: Defense in get_tree().get_nodes_in_group("defenses"):
        if defense == null:
            push_error("Defense class not defined for a tagged defense!")
        else:
            group.append(defense)

    return group
