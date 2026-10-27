extends Control

@onready var exit_btn = $Exit
@onready var grid_container = $GridContainer
@onready var hover_sound = $HoverSound

func _ready() -> void:
	get_tree().paused = false
	if exit_btn:
		if not exit_btn.pressed.is_connected(_on_exit_pressed):
			exit_btn.pressed.connect(_on_exit_pressed)
		if not exit_btn.mouse_entered.is_connected(_on_button_hovered.bind(exit_btn)):
			exit_btn.mouse_entered.connect(_on_button_hovered.bind(exit_btn))
		
	update_level_buttons()

func update_level_buttons() -> void:
	var level_buttons = grid_container.get_children()
	
	for i in range(level_buttons.size()):
		var level_num = i + 1
		var btn = level_buttons[i] as Button
		
		if btn == null:
			continue
			
		var scene_path = "res://scenes/levels/level_" + str(level_num) + ".tscn"
		
		if not btn.pressed.is_connected(_on_level_pressed.bind(scene_path)):
			btn.pressed.connect(_on_level_pressed.bind(scene_path))
			
		if not btn.mouse_entered.is_connected(_on_button_hovered.bind(btn)):
			btn.mouse_entered.connect(_on_button_hovered.bind(btn))
			
		if level_num <= Global.highest_unlocked_level:
			btn.disabled = false
		else:
			btn.disabled = true
			
		if level_num in Global.completed_levels:
			btn.modulate = Color(1, 0.85, 0)
		else:
			btn.modulate = Color.WHITE

func _on_level_pressed(scene_path: String) -> void:
	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
	else:
		print("Scene path not found: ", scene_path)

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_button_hovered(btn: Button) -> void:
	if btn and btn.disabled:
		return
		
	if hover_sound and hover_sound.stream:
		hover_sound.stop()
		hover_sound.play()
