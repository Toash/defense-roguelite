extends CanvasLayer

# wires player behaviour stuff onto the UI


# @export var hotbar_input: HotbarInput


@export var inventory_window: ExpandableWindow
@export var pickup_window: ExpandableWindow
@export var world_container_window: ExpandableWindow
@export var crafting_window: ExpandableWindow

@export var hotbar_ui: HotbarUI
@export var health_bar: ProgressBar

@export_group("in code")
@export var player: Player

func _ready() -> void:
	var player_health: Health = player.get_health()
	player_health.health_changed.connect(_on_health_changed)
	health_bar.max_value = player_health.max_health
	health_bar.value = player_health.health


	# attach containers to the uis 
	hotbar_ui.container = player.get_hotbar()
	(inventory_window.get_content() as ContainerUI).container = player.get_inventory()
	(pickup_window.get_content() as ContainerUI).container = player.get_pickups()
	# setup the uis
	hotbar_ui.setup()
	(inventory_window.get_content() as ContainerUI).setup()
	(pickup_window.get_content() as ContainerUI).setup()

	var hotbar_input: HotbarInput = player.get_hotbar_input()
	hotbar_input.equip_slot.connect(hotbar_ui.on_equip_slot)


	# Show container ui when opening container.
	var world_container_input: WorldContainerInput = player.get_world_container_input()

	world_container_input.container_interacted.connect(_on_container_interact)
	world_container_input.container_changed.connect(_on_container_changed)


	(crafting_window.get_content() as CraftingUI).setup(player.get_player_crafting().get_blueprints())


func _on_health_changed(health: int):
	health_bar.value = health


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
