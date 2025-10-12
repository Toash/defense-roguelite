extends CharacterBody2D

@export var speed = 250


var state = "idle"
var input_vector = Vector2.ZERO

@onready var sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		state = "walk"
		sprite.animation = "walk"
	else:
		state = "idle"
		sprite.animation = "idle"

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()


func _physics_process(delta: float) -> void:
	if Console.input.has_focus(): return


	input_vector = Vector2.ZERO
	if Input.is_action_pressed("up"):
		input_vector.y -= 1
	if Input.is_action_pressed("down"):
		input_vector.y += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
		sprite.flip_h = true
	if Input.is_action_pressed("right"):
		input_vector.x += 1
		sprite.flip_h = false

func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.NO_RELOAD,
		SaveManager.SaveKeys_NO_RELOAD.PATH: get_path(),

		"position_x": position.x,
		"position_y": position.y,
	}

func load(d: Dictionary):
	position.x = d.position_x
	position.y = d.position_y
