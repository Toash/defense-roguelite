extends CharacterBody2D

class_name Player


@export var speed = 250

@export var inventory: ItemContainer
@export var hotbar: ItemContainer
@export var pickups: ItemContainer


var state = "idle"
var input_vector = Vector2.ZERO

@export var health: Health
@export var thirst: DrainingStat
@export var hunger: DrainingStat

@export var hotbar_input: HotbarInput
@export var world_container_input: WorldContainerInput

func _ready() -> void:
	Game.player_load()


func _process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		state = "walk"
	else:
		state = "idle"
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
	if Input.is_action_pressed("right"):
		input_vector.x += 1


func get_health() -> Health:
	return health
func get_inventory() -> ItemContainer:
	return inventory
func get_pickups() -> ItemContainer:
	return pickups
func get_hotbar() -> ItemContainer:
	return hotbar
func get_hotbar_input() -> HotbarInput:
	return hotbar_input
func get_world_container_input() -> WorldContainerInput:
	return world_container_input


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.NO_RELOAD,
		SaveManager.SaveKeys_NO_RELOAD.SCENETREE_PATH: get_path(),

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
