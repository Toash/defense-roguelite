# ActorSpawner (autolaod)
extends Node

# class_name ActorSpawner


func spawn_actor(actor_key: ActorRegistry.KEY, global_position: Vector2):
    var actor: Node2D = ActorRegistry.get_actor(actor_key)
    actor.global_position = global_position
    get_tree().root.add_child(actor)

func spawn_actor_on_player(actor_key: ActorRegistry.KEY):
    var actor: Node2D = ActorRegistry.get_actor(actor_key)

    actor.global_position = get_tree().get_first_node_in_group("player").global_position
    get_tree().root.add_child(actor)

func spawn_actor_near_player(actor_key: ActorRegistry.KEY):
    var actor: Node2D = ActorRegistry.get_actor(actor_key)

    actor.global_position = get_tree().get_first_node_in_group("player").global_position + (Vector2.UP * 200)

    get_tree().root.add_child(actor)