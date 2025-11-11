extends Area2D

## detects nearby fogs in FOV and removes them.
class_name FogDissipator


var nearby_fog: Array[Fog]

@export var player: Node2D

## mask shnould only detect obstructions
@export var obstruction_raycast: RayCast2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(delta):
	for fog in nearby_fog:
		obstruction_raycast.target_position = fog.position
		if not obstruction_raycast.is_colliding():
			nearby_fog.erase(fog)
			fog.dissipate()


func _on_area_entered(area: Area2D) -> void:
	var fog := area as Fog
	if fog == null:
		push_error("Fog script not found ")

	nearby_fog.append(fog)

func _on_area_exited(area: Area2D) -> void:
	var fog := area as Fog
	if fog == null:
		push_error("Fog script not found ")

	nearby_fog.erase(fog)
