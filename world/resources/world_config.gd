extends Resource


class_name WorldConfig


@export_group("World Size")
@export var world_width = 128
@export var world_height = 128

@export_group("Base Size")
@export var base_width = 24
@export var base_height = 24


@export_group("Source IDs")
@export var altitude_to_source_id: Dictionary[WorldEnums.ALTITUDE, int] = {
	WorldEnums.ALTITUDE.WATER: 2,
	WorldEnums.ALTITUDE.DIRT: 1,
	WorldEnums.ALTITUDE.GRASS: 0,
}
@export var resource_to_source_id: Dictionary[WorldEnums.RESOURCE, int] = {
	WorldEnums.RESOURCE.TREE: 0
}

@export_group("Alternative IDs")
@export var resource_to_alternative_id: Dictionary[WorldEnums.RESOURCE, int] = {
	WorldEnums.RESOURCE.TREE: 1
}


@export_group("Probabilities")
## Should go from lowest to highest max value.
@export var altitude_bands: Array[AltitudeBand] = []
@export var resource_bands: Array[ResourceBand] = []
