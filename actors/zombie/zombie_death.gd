extends Node

class_name ZombieDeath


func _on_death():
    get_parent().queue_free()