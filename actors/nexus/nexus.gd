extends Node2D


## drills stuff, gets resources
## enemies will try to destroy this, if they do the run is over.
class_name Nexus


@export var area: Area2D
@export var health: Health
@export var sprite: Sprite2D

var interactable: Interactable

func _ready():
	#broadcast that this is now in the world, so that enemies can attack
	var world = get_node("/root/World") as World


	area.body_entered.connect(_on_body_entered)
	_setup_interactable()


func _on_body_entered(body: Node2D):
	if body is RuntimeEnemy:
		pass
		# health.damage(1)
		# body.queue_free()

func _setup_interactable():
	# TODO: Specify interactable radius
	interactable = Interactable.create_interactable(10)

	interactable.sprite = sprite
	interactable.interacted.connect(_on_interacted)

	add_child(interactable)

func _on_interacted(player: Player):
	print("interacted with nexus")
