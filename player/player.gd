extends CharacterBody2D

@export var speed = 250


var state = "idle"

@onready var sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	var input_vector = Vector2.ZERO

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

	if input_vector != Vector2.ZERO:
		state = "walk"
		sprite.animation = "walk"
	else:
		state = "idle"
		sprite.animation = "idle"

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()
