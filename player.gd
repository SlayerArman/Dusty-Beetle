extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move left", "move right", "move up", "move down")
	print("Input: ", input_dir)
	
	velocity = input_dir * speed
	move_and_slide()
