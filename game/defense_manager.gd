extends Node2D


## runtime class for managing defenses in the game
class_name DefenseManager

func get_defenses() -> Array[RuntimeDefense]:
    var group: Array[RuntimeDefense] = []
    for defense: RuntimeDefense in get_tree().get_nodes_in_group("defenses"):
        if defense == null:
            push_error("RuntimeDefense class not defined for a tagged defense!")
        else:
            group.append(defense)

    return group