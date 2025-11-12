extends Area2D


## detects nearby interactables, has method to get the nearest one.
## ensure that this mask can only detect interactables.
class_name InteractDetector

signal nearest_interactable_changed(interactable: Interactable)


@export var player: Node2D
@export var raycast: RayCast2D

var nearby_interactables: Dictionary[Interactable, float]
var nearest_interactable: Interactable = null

func _ready():
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)


func _process(delta: float) -> void:
    # print(nearby_interactables)
    # update distances between interactables.
    for interactable: Interactable in nearby_interactables:
        var distance = (player.global_position - interactable.global_position).length()
        nearby_interactables[interactable] = distance

    if nearest_interactable != get_nearest_interactable():
        # print("nearest interactable changed")
        # print(nearest_interactable)
        # print(get_nearest_interactable())
        nearest_interactable_changed.emit(get_nearest_interactable())
        nearest_interactable = get_nearest_interactable()

func has_interactable(interactable: Interactable):
    for nearby_interactable in nearby_interactables:
        if nearby_interactable == interactable:
            return true
    
    return false

func get_nearest_interactable() -> Interactable:
    var _nearest_interactable = null
    var _nearest_distance: float = INF
    for interactable: Interactable in nearby_interactables:
        var distance: float = nearby_interactables[interactable]
        if distance < _nearest_distance:
            _nearest_interactable = interactable
            _nearest_distance = distance
    return _nearest_interactable


func _on_area_entered(area: Area2D) -> void:
    var interactable = area as Interactable
    if interactable == null:
        push_error("Interactable script not found on an interactable!")

    var distance = (player.global_position - area.global_position).length()
    nearby_interactables[interactable] = distance

    
func _on_area_exited(area: Area2D) -> void:
    var interactable = area as Interactable
    if interactable == null:
        push_error("Interactable script not found on an interactable!")

    nearby_interactables.erase(interactable)
