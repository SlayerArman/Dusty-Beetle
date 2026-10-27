extends Button

@onready var click_sound = $clicked
@onready var hover_sound = $HoverSound

func _ready() -> void:
	pressed.connect(_on_play_pressed)
	mouse_entered.connect(_on_button_hovered)

func _on_play_pressed() -> void:
	click_sound.play()
	await get_tree().create_timer(0.5).timeout 
	get_tree().quit()

func _on_button_hovered() -> void:
	hover_sound.play()
