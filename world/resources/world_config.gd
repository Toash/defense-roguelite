extends Resource


class_name WorldConfig


@export_group("World Size")
@export var world_width = 64
@export var world_height = 64

@export_group("Base Size")
@export var base_radius = 8
@export var base_width = 8
@export var base_height = 8


@export_group("Tiles")
@export var altitude_enum_to_tile: Dictionary[WorldEnums.ALTITUDE, TileInfo] = {
}
@export var resource_enum_to_tile: Dictionary[WorldEnums.RESOURCE, TileInfo] = {
}


@export_group("Probabilities")
## Should go from lowest to highest max value.
@export var altitude_bands: Array[AltitudeBand] = []
@export var resource_bands: Array[ResourceBand] = []
