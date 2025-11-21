@abstract class_name State
extends Node2D

signal transitioned(current_state: State, new_state: String)

@abstract
func state_enter()

@abstract
func state_update(delta: float)

@abstract
func state_physics_update(delta: float)

@abstract
func state_exit()