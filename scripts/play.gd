extends Button

@onready var click_sound = $clicked

func _ready() -> void:
	pressed.connect(_on_play_pressed)

func _on_play_pressed() -> void:
	click_sound.play()
	
	await get_tree().create_timer(0.5).timeout 
	
	get_tree().change_scene_to_file("res://main.tscn")
	
