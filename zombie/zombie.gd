extends CharacterBody2D

@export var speed: float = 95.0
@export var attack_cooldown: float = 0.8
@export var damage: int = 10
@export var max_hp: int = 30

var hp: int
var target: Node2D = null
var state := "idle"
var _attack_cd: float = 0.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var vision: Area2D = $Vision
@onready var attack_area: Area2D = $AttackArea
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	hp = max_hp
	nav.path_desired_distance = 4.0
	nav.target_desired_distance = 8.0

	vision.body_entered.connect(_on_body_entered_vision)
	vision.body_exited.connect(_on_body_exited_vision)
	attack_area.body_entered.connect(_on_attack_area_entered)
	

func _physics_process(delta: float) -> void:
	if _attack_cd > 0.0:
		_attack_cd -= delta

	match state:
		"idle":
			velocity = Vector2.ZERO
			if target:
				state = "chase"
		"chase":
			if target and is_instance_valid(target):
				nav.target_position = target.global_position

				var next_point = nav.get_next_path_position()
				var direction = (next_point - global_position).normalized()
				if direction.x > 0:
					sprite.flip_h = false
				else:
					sprite.flip_h = true


				velocity = direction * speed

				if attack_area.overlaps_body(target):
					state = "attack"
			else:
				target = null
				state = "idle"
		"attack":
			if not target or not is_instance_valid(target):
				state = "idle"
			elif not attack_area.overlaps_body(target):
				state = "chase"
			elif _attack_cd <= 0.0:
				_deal_damage()
				_attack_cd = attack_cooldown
	move_and_slide()
	print(state)

func _on_body_entered_vision(body: Node) -> void:
	if body.name == "Player": # or `body.is_in_group("player")`
		target = body

func _on_body_exited_vision(body: Node) -> void:
	if body == target:
		target = null

func _on_attack_area_entered(body: Node) -> void:
	if body == target:
		state = "attack"

func _deal_damage() -> void:
	if target and is_instance_valid(target) and attack_area.overlaps_body(target):
		if "apply_damage" in target:
			target.apply_damage(damage)

func apply_damage(amount: int, knockback := Vector2.ZERO) -> void:
	hp -= amount
	if knockback != Vector2.ZERO:
		velocity += knockback
	if hp <= 0:
		queue_free()
