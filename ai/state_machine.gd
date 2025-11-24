extends Node2D

class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary[String, State] = {}
var font: Font = preload("res://ui/fonts/Poco.ttf")


func _ready() -> void:
	current_state = initial_state
	current_state.state_enter()

	for node in get_children():
		if node is State:
			states[node.name.to_lower()] = node
			node.transitioned.connect(_on_transition)
	queue_redraw()

		
func _process(delta: float) -> void:
	if current_state:
		current_state.state_update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.state_physics_update(delta)


func _on_transition(from: State, to: String):
	queue_redraw()
	if from != current_state:
		push_error("State Machine: from state does not match current state")
		return

	var next_state: State = states.get(to, null)
	if next_state == null:
		push_error("State Machine: Could not find to state in array of states.")


	print("State Machine: Switching states from " + from.name + " to " + next_state.name.capitalize())

	current_state.state_exit()
	current_state = next_state
	current_state.state_enter()


func _draw() -> void:
	if not Game.debug_state_machines: return
	self.z_index = 999
	# matrix that cancels nodes global transform
	var inv = get_global_transform().affine_inverse()
	draw_set_transform_matrix(inv)
	draw_string(font, global_position, current_state.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16)
	draw_set_transform_matrix(Transform2D()) # reset
	# draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
