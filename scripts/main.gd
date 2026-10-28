extends Node2D

var stomp_scene = preload("res://scenes/Stomp.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var time_label = $CanvasLayer/Label
@onready var high_score_label = $CanvasLayer/Highscore
@onready var game_over_label = $CanvasLayer/Squished
@onready var game_over_black = $CanvasLayer/Black
@onready var death_sound = $DeathSound
@onready var player = $Player
@onready var press_space = $CanvasLayer/PressSPACE

var time_survived: float = 0.0
var is_dead: bool = false

var speed_increase_amount: float = 1.5 

func _ready() -> void:
	spawn_timer.wait_time = 0.8 
	
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		
	spawn_timer.start()
	
	if high_score_label:
		high_score_label.text = "Best: " + str(snapped(Global.high_score, 0.1)) + "s"

func _process(delta: float) -> void:
	if is_dead:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return

	time_survived += delta
	time_label.text = "Survived: " + str(snapped(time_survived, 0.1)) + "s"
	
	if time_survived > Global.high_score and high_score_label:
		high_score_label.text = "Best: " + str(snapped(time_survived, 0.1)) + "s"

func game_over() -> void:
	is_dead = true
	spawn_timer.stop()
	
	var is_new_record = Global.update_high_score(time_survived)
	if is_new_record and high_score_label:
		high_score_label.text = "Best: " + str(snapped(Global.high_score, 0.1)) + "s (NEW!)"
		
	game_over_label.show()
	game_over_black.show()
	death_sound.play()
	press_space.show()

func _on_spawn_timer_timeout() -> void:
	if is_dead: return
	
	var stomp = stomp_scene.instantiate()
	var screen_size = get_viewport_rect().size
	stomp.position = Vector2(
		randf_range(50, screen_size.x - 50),
		randf_range(50, screen_size.y - 50)
	)
	add_child(stomp)
	
	if spawn_timer.wait_time > 0.2:
		spawn_timer.wait_time -= 0.005
		
		if player and "speed" in player:
			player.speed += speed_increase_amount
