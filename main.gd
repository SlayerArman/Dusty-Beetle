extends Node2D

var stomp_scene = preload("res://stomp.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var time_label = $CanvasLayer/Label 
@onready var game_over_label = $CanvasLayer/GameOverLabel

var time_survived: float = 0.0
var is_dead: bool = false

func _ready():
	spawn_timer.wait_time = 0.8 

func _process(delta):
	if is_dead:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return

	time_survived += delta
	time_label.text = "Survived: " + str(snapped(time_survived, 0.1)) + "s"

func game_over():
	is_dead = true
	spawn_timer.stop()
	game_over_label.show()

func _on_spawn_timer_timeout():
	if is_dead: return
	
	var stomp = stomp_scene.instantiate()
	var screen_size = get_viewport_rect().size
	stomp.position = Vector2(
		randf_range(50, screen_size.x - 50), 
		randf_range(50, screen_size.y - 50)
	)
	add_child(stomp)
	
	if spawn_timer.wait_time > 0.2:
		spawn_timer.wait_time -= 0.02
