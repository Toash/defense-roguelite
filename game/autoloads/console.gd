extends CanvasLayer


# Autoload for console
# Can register commands that can be executed ingame.

@export var logs: RichTextLabel
@export var input: LineEdit


var commands: Dictionary[String, Callable] = {}

const DELIMITER = " "
var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_open(false)
	input.text_submitted.connect(_handle_console_input)
	input.gui_input.connect(_on_input_gui)

	_register_command("spawn_item", func(id, x, y, amount):
		GroundItems.spawn_by_id(int(id), int(amount), Vector2(int(x), int(y)))
		)

	# _register_command("spawn_item_name", func(item_name, x, y, amount):
	# 	GroundItems.spawn_by_name(item_name, int(amount), Vector2(int(x), int(y)))
	# 	)

	_register_command("spawn_item_here", func(item_name, amount):
		GroundItems.spawn_by_name_on_player(item_name, int(amount))
		)

	_register_command("spawn_pawn", func(name: String):
		PawnSpawner.spawn_pawn_near_player(PawnRegistry.get_key(name), Vector2.UP * 100)
		)

	_register_command("spawn_horde", func(amount):
		PawnSpawner.spawn_horde(PawnEnums.NAME.BASIC_ZOMBIE, int(amount))
		)

	_register_command("new_world", func():
		var world: World = get_tree().get_first_node_in_group("world") as World
		if world:
			world._setup()
		)


	_register_command("items", func():
		var items = ItemDatabase.get_all()
		
		if items.is_empty():
			_log("No items registered.")
			return

		for data in items:
			_log("id: " + str(data.id) + "\t\tname: " + str(data.display_name))
	)


func _log(message: String):
	logs.append_text(message + "\n")

func _register_command(command_name: String, callable: Callable):
	commands[command_name] = callable

func _handle_console_input(text: String):
	var text_array = text.split(DELIMITER)
	var command: String
	var arguments: Array

	for i in text_array.size():
		if i == 0:
			command = text_array.get(i)
		else:
			arguments.append(text_array.get(i))

	print("Console: Entered command " + command + " with arguments " + str(arguments))

	if commands.has(command):
		commands[command].callv(arguments)
	else:
		_log("Command " + text + " not found.")
 
	input.clear()
	
	# input.call_deferred("grab_focus")


func set_open(b: bool):
	if b:
		open = true
		visible = true
		input.grab_focus()
	else:
		open = false
		visible = false

func is_open() -> bool:
	return open

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("console"):
		if open:
			set_open(false)
		else:
			set_open(true)


	if OS.is_debug_build() and event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_N:
			if event.is_pressed():
				var world: World = get_tree().get_first_node_in_group("world") as World
				if world:
					world._setup()

func _on_input_gui(event: InputEvent):
	if event is InputEventKey and event.is_pressed():
		# `
		if event.keycode == 96:
			set_open(false)
			get_viewport().set_input_as_handled()
