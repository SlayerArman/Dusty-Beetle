extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@export var speed: float = 300.0
var is_dead = false

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move left", "move right", "move up", "move down")
	if is_dead: return
	
	if input_dir != Vector2.ZERO:
		anim.play("Running")
		anim.rotation = input_dir.angle() + PI/2
	else:
		anim.play("Idle")

	velocity = input_dir * speed
	move_and_slide()

func die():
	is_dead = true
	anim.play("Death")
