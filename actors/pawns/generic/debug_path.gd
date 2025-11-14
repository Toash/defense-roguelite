extends Node2D


class_name DebugPath

var path: PackedVector2Array = PackedVector2Array()

func set_path(new_path: PackedVector2Array) -> void:
    path = new_path
    queue_redraw() # tells Godot to call _draw()

func _draw() -> void:
    if path.size() < 2:
        return

    for i in range(path.size() - 1):
        draw_line(path[i], path[i + 1], Color.RED, 2.0)
