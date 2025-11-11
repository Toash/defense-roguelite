extends Node


## Generic class for a stat that drains over time (hunger, thirst, etc..)
class_name DrainingStat

signal poll(value: int)
signal low_threshold
signal empty


@export var max_stat: float = 100
@export var drain_rate: float = 0.01
@export var low_threshold_value: int = 30

@onready var polling_timer: Timer = Timer.new()

var stat: float

const polling_rate = 3

func _ready() -> void:
    stat = max_stat

    polling_timer.wait_time = polling_rate
    polling_timer.autostart = true
    polling_timer.timeout.connect(_on_timeout)
    add_child(polling_timer)

func _process(delta):
    stat -= drain_rate * delta
    if stat <= low_threshold_value:
        low_threshold.emit()

    if stat <= 0:
        empty.emit()

func _on_timeout():
    # print("asdbfiosabf")
    poll.emit(int(stat))


func to_dict() -> Dictionary:
    return {
        "stat" = self.stat,
        "max_stat" = self.max_stat,
        "drain_rate" = self.drain_rate,
    }

func from_dict(dict: Dictionary):
    max_stat = dict.max_stat
    stat = dict.stat
    drain_rate = dict.drain_rate
