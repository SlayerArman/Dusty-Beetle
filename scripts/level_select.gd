extends Control

@onready var level1_btn = $HBoxContainer/Level1
@onready var level2_btn = $HBoxContainer/Level2

func _ready() -> void:
	level1_btn.pressed.connect(_on_level1_pressed)
	level2_btn.pressed.connect(_on_level2_pressed)

func _on_level1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_level2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
