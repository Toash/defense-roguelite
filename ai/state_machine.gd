extends Node

class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary[String, State] = {}


func _ready() -> void:
    current_state = initial_state

    for node in get_children():
        if node is State:
            states[node.name.to_lower()] = node
            node.transitioned.connect(_on_transition)

        
func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)


func _on_transition(from: State, to: State):
    if from != current_state: return

    if !states.has(from.name): return
    if !states.has(to.name): return

    current_state.exit()
    current_state = to
    current_state.enter()
