extends Area2D

@onready var sprite = $Sprite2D
@onready var col = $CollisionShape2D
@onready var timer = $Timer

var stomp_delay = 1.5

func _ready():
	sprite.modulate = Color(0, 0, 0, 0.4)
	col.set_deferred("disabled", true) 
	timer.wait_time = stomp_delay
	timer.start()

func _process(_delta):
	if not timer.is_stopped():
		var progress = 1.0 - (timer.time_left / stomp_delay)
		scale = Vector2(1, 1) + Vector2(2, 2) * progress

func _on_timer_timeout():
	sprite.modulate = Color(1, 0, 0, 1)
	col.set_deferred("disabled", false)
	
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		print("Squished!")
		get_tree().reload_current_scene()
