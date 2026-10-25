extends Area2D

@onready var shoe_sprite = $ShoeSprite
@onready var col = $CollisionShape2D
@onready var timer = $Timer

var stomp_delay = 1.5
var is_falling = true 

func _ready():
	timer.one_shot = true 
	shoe_sprite.modulate = Color(0, 0, 0, 0.5)
	scale = Vector2(0.2, 0.2)
	col.set_deferred("disabled", true)
	timer.wait_time = stomp_delay
	timer.start()
	
func _process(_delta):
	if is_falling and not timer.is_stopped():
		var progress = 1.0 - (timer.time_left / stomp_delay)
		var current_scale = lerp(0.2, 1.0, progress)
		scale = Vector2(current_scale, current_scale)

func _on_timer_timeout():
	is_falling = false 
	
	shoe_sprite.modulate = Color(1, 1, 1, 1)
	scale = Vector2(1, 1) 
	
	col.set_deferred("disabled", false)
	
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().current_scene.game_over()
		body.queue_free()
