extends TargetProvider


## provides target for nav agent
class_name NavTargetProvider

@export var agent: NavigationAgent2D


func _process(delta):
    target_pos_emitted.emit(agent.target_position)


func get_global_pos() -> Vector2:
    return agent.target_position