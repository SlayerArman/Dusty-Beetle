extends AnimatedSprite2D

var start_x: float
var move_distance: float = 2000.0
var speed: float = 200.0
var direction: int = 1

func _ready() -> void:
	start_x = position.x
	play("moving")

func _process(delta: float) -> void:
	position.x += speed * direction * delta

	if position.x >= start_x + move_distance:
		direction = -1
		flip_h = true

	elif position.x <= start_x:
		direction = 1
		flip_h = false
