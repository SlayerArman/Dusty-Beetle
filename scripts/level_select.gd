extends Control

@onready var level1_btn = $GridContainer/level1

func _ready() -> void:
	get_tree().paused = false
	level1_btn.pressed.connect(_on_level1_pressed)

func _on_level1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
