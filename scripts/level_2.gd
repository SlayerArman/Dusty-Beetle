extends Node2D

var stomp_scene = preload("res://scenes/Stomp.tscn")

@onready var hover_sound = $HoverSound
@onready var win_sound = $VictorySound
@onready var level_timer = $LevelTimer
@onready var win_ui = $WinUI
@onready var pause_ui = $PauseUI
@onready var continue_btn = $WinUI/NextLevel
@onready var spawn_timer = $SpawnTimer
@onready var time_label = $CanvasLayer/Label
@onready var game_over_label = $CanvasLayer/Squished
@onready var game_over_black = $CanvasLayer/Black
@onready var death_sound = $DeathSound
@onready var press_space = $CanvasLayer/PressSPACE

var is_dead: bool = false
var is_won: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	win_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	hover_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	win_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	
	spawn_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	level_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	if has_node("Player"):
		$Player.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	pause_ui.hide()
	
	continue_btn.mouse_entered.connect(_on_button_hovered)
	continue_btn.pressed.connect(_on_continue_pressed)
	
	spawn_timer.wait_time = 0.8
	
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	if not level_timer.timeout.is_connected(_on_level_complete):
		level_timer.timeout.connect(_on_level_complete)

	spawn_timer.start()
	level_timer.start()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_P:
			toggle_pause()

func toggle_pause() -> void:
	if is_dead or is_won:
		return

	var currently_paused = get_tree().paused
	get_tree().paused = !currently_paused
	pause_ui.visible = !currently_paused

func _process(delta: float) -> void:
	if get_tree().paused:
		return

	if is_dead:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return

	var time_left = max(0.0, level_timer.time_left)
	time_label.text = "Time Left: " + str(snapped(time_left, 0.1)) + "s"

func _on_level_complete() -> void:
	if is_dead: return
	
	is_won = true
	spawn_timer.stop()
	level_timer.stop()
	time_label.text = "Time Left: 0.0s"
	win_ui.show()
	win_sound.play()
	
	Global.complete_level(2)
	
	get_tree().paused = true

func _on_continue_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_button_hovered() -> void:
	if hover_sound and hover_sound.stream:
		hover_sound.stop()
		hover_sound.play()

func game_over() -> void:
	if is_won: return
	
	is_dead = true
	spawn_timer.stop()
	level_timer.stop()
	game_over_label.show()
	game_over_black.show()
	death_sound.play()
	press_space.show()

func _on_spawn_timer_timeout() -> void:
	if is_dead or is_won or get_tree().paused: return
	
	var stomp = stomp_scene.instantiate()
	
	stomp.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	var screen_size = get_viewport_rect().size
	stomp.position = Vector2(
		randf_range(50, screen_size.x - 50),
		randf_range(50, screen_size.y - 50)
	)
	add_child(stomp)
	
	if spawn_timer.wait_time > 0.2:
		spawn_timer.wait_time -= 0.005
