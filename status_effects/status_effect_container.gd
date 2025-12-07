extends Node2D

## node to hold all status effects at runtime.
class_name PawnStatusEffectContainer

signal added_status_effect(node: RuntimePawnStatusEffect)
signal removed_status_effect(node: RuntimePawnStatusEffect)

var pawn: Pawn

func _init():
    print("adding container")
func _ready():
    if pawn == null:
        push_error("PawnStatusEffectContainer: Pawn not defined")

func setup(pawn: Pawn):
    self.pawn = pawn

func add_status_effect(node: RuntimePawnStatusEffect):
    print("adding status effect")

    # check for existing status effects

    # for status_effect: RuntimePawnStatusEffect in get_children():
    #     if 


    add_child(node)
    added_status_effect.emit()
    node.removed_status_effect.connect(func():
        removed_status_effect.emit()
        )


func clear_status_effects():
    for status_effect: RuntimePawnStatusEffect in get_children():
        status_effect._on_exit(pawn)

        status_effect.call_deferred("queue_free")
