extends Node3D

var scene := preload("res://GameObjects/Enemy.tscn")
@export var players_node: Node
var wait: float = 1.0
var running: bool = false
var difficulty = 0

func begin():
	if multiplayer.is_server():
		get_tree().create_timer(wait).timeout.connect(spawnTimer_timeout)
		running = true
		wait -= difficulty*0.05
		wait = clamp(wait,0.3,5)

func stop():
	for enemy in get_children():
		remove_child(enemy)
		enemy.queue_free()
	wait = 1.0
	running = false

func spawnTimer_timeout():
	if not running:
		return
	if not players_node:
		push_warning("Players node not set!")
		return
	if get_child_count() < 101:
		var scene_instance = scene.instantiate()
		scene_instance.set_name("enemy")
		var pos_mult = Vector2(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0))
		pos_mult = pos_mult.normalized()
		scene_instance.transform.origin.x = pos_mult.x * 40
		scene_instance.transform.origin.z = pos_mult.y * 40
		scene_instance.players_node = players_node
		scene_instance.WALK_SPEED += difficulty/5
		add_child(scene_instance, true)
	get_tree().create_timer(wait).timeout.connect(spawnTimer_timeout)
	if wait > 0.1:
		wait -= wait/100
