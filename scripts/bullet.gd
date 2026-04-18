extends CharacterBody2D

var speed = 1000

func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()
