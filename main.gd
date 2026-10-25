extends Node2D

var stomp_scene = preload("res://stomp.tscn")
@onready var spawn_timer = $SpawnTimer

func _ready():
	spawn_timer.wait_time = 0.8

func _on_spawn_timer_timeout():
	var stomp = stomp_scene.instantiate()

	var screen_size = get_viewport_rect().size
	var random_x = randf_range(50, screen_size.x - 50)
	var random_y = randf_range(50, screen_size.y - 50)

	stomp.position = Vector2(random_x, random_y)
	add_child(stomp)
