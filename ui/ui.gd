extends CanvasLayer

# wires player behaviour stuff onto the UI


# @export var hotbar_input: HotbarInput


@export var inventory_window: ExpandableWindow
@export var pickup_window: ExpandableWindow
@export var world_container_window: ExpandableWindow


@export var hotbar_ui: HotbarUI
@export var health_bar: ProgressBar
@export var hunger_bar: ProgressBar
@export var thirst_bar: ProgressBar

@export_group("in code")
@export var player: Player

func _ready() -> void:
	var player_health: Health = player.get_health()
	if not player_health: push_error("UI: player health not found")
	player_health.health_changed.connect(_on_health_changed)
	health_bar.max_value = player_health.max_health
	health_bar.value = player_health.health

	var player_hunger: DrainingStat = player.hunger
	if not player_hunger: push_error("UI: player hunger not found")
	player_hunger.poll.connect(_on_hunger_poll)
	hunger_bar.max_value = player_hunger.max_stat
	hunger_bar.value = player_hunger.stat


	var player_thirst: DrainingStat = player.thirst
	if not player_thirst: push_error("UI: player thirst not found")
	player_thirst.poll.connect(_on_thirst_poll)
	thirst_bar.max_value = player_thirst.max_stat
	thirst_bar.value = player_thirst.stat


	# attach containers to the uis 
	hotbar_ui.container = player.get_hotbar()
	(inventory_window.get_content() as ContainerUI).container = player.get_inventory()
	(pickup_window.get_content() as ContainerUI).container = player.get_pickups()
	# setup the uis
	hotbar_ui.setup()
	(inventory_window.get_content() as ContainerUI).setup()
	(pickup_window.get_content() as ContainerUI).setup()

	var hotbar_input: HotbarInput = player.get_hotbar_input()
	if not hotbar_input: push_error("UI: Could not find hotbar input in player")
	hotbar_input.equip_slot.connect(hotbar_ui.on_equip_slot)


	# Show container ui when opening container.
	var world_container_input: WorldContainerInput = player.get_world_container_input()
	if world_container_input == null:
		push_error("Could not find World Container Input on the player!")

	world_container_input.container_interacted.connect(_on_container_interact)
	world_container_input.container_changed.connect(_on_container_changed)


func _on_health_changed(health: int):
	health_bar.value = health

func _on_hunger_poll(hunger: int):
	hunger_bar.value = hunger

func _on_thirst_poll(thirst: int):
	thirst_bar.value = thirst

func _on_container_interact(item_container: ItemContainer):
	_set_world_container_ui(item_container)
	world_container_window.toggle()

func _on_container_changed(item_container: ItemContainer):
	_set_world_container_ui(item_container)


func _set_world_container_ui(item_container: ItemContainer):
	var container_ui: ContainerUI = world_container_window.get_content() as ContainerUI
	if container_ui == null:
		push_error("UI: Could not find Container UI in the world container window")

	container_ui.container = item_container
	container_ui.setup()
