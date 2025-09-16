extends Control
@onready var slots_ui := $Slots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Hotbar.num_slots):
		var b := Button.new()
		b.name = str(i)
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(64, 64)
		slots_ui.add_child(b)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
