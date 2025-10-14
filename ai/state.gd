extends Node


class_name State


signal transitioned(current_state: State, new_state: String)


func state_enter():
    pass

func state_update(delta: float):
    pass

func state_physics_update(delta: float):
    pass

func state_exit():
    pass