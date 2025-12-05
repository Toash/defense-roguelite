extends Pawn

class_name Player


@export var speed = 250
@export var camera: Camera2D

@export_group("Containers")
@export var containers: PlayerContainers
@export var coins: PlayerCoins
@export var inventory: ItemContainer
@export var hotbar: ItemContainer
@export var hotbar_equipped_inst: HotbarEquippedInst
@export var pickups: ItemContainer

@export_group("Crafting")
@export var player_crafting: PlayerCrafting

@export_group("Defenses")
@export var player_defenses: PlayerDefenses


var state = "idle"
var input_vector = Vector2.ZERO


@export_group("Inputs")
@export var hotbar_input: HotbarInput
@export var world_container_input: WorldContainerInput
@export var context_input: ContextInput

var dead = false

func _ready() -> void:
	Game.player_load(self)


func _process(delta: float) -> void:
	# super._process(delta)
	if dead: return
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
func get_hotbar_equipped_inst() -> HotbarEquippedInst:
	return hotbar_equipped_inst
func get_hotbar_input() -> HotbarInput:
	return hotbar_input
func get_world_container_input() -> WorldContainerInput:
	return world_container_input
func get_context_input() -> ContextInput:
	return context_input
func get_player_crafting() -> PlayerCrafting:
	return self.player_crafting


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.NO_RELOAD,
		SaveManager.SaveKeys_NO_RELOAD.SCENETREE_PATH: get_path(),

		"position_x": position.x,
		"position_y": position.y,

		"health_data": health.to_dict(),

	}

func load(d: Dictionary):
	position.x = d.position_x
	position.y = d.position_y

	health.from_dict(d.health_data)
	health.health_changed.emit(health.health)


	Game.player_load(self)
