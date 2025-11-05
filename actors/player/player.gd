extends CharacterBody2D

class_name Player

@export var speed = 250

@export var inventory: ItemContainer
@export var hotbar: ItemContainer
@export var pickups: ItemContainer


var state = "idle"
var input_vector = Vector2.ZERO

@onready var health: Health = get_node_or_null("Health") as Health
@onready var thirst: DrainingStat = get_node_or_null("Thirst") as DrainingStat
@onready var hunger: DrainingStat = get_node_or_null("Hunger") as DrainingStat

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	Game.player_load()


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


func get_inventory() -> ItemContainer:
	return inventory
func get_pickups() -> ItemContainer:
	return pickups
func get_hotbar() -> ItemContainer:
	return hotbar


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.NO_RELOAD,
		SaveManager.SaveKeys_NO_RELOAD.PATH: get_path(),

		"position_x": position.x,
		"position_y": position.y,

		"health_data": health.to_dict(),
		"hunger_data": hunger.to_dict(),
		"thirst_data": thirst.to_dict(),

	}

func load(d: Dictionary):
	position.x = d.position_x
	position.y = d.position_y

	health.from_dict(d.health_data)
	health.health_changed.emit(health.health)

	hunger.from_dict(d.hunger_data)
	hunger.poll.emit(hunger.stat)

	thirst.from_dict(d.thirst_data)
	thirst.poll.emit(thirst.stat)

	Game.player_load()
