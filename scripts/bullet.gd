extends CharacterBody2D
@onready var sprite = $Polygon2D
var speed = 1000

func _physics_process(delta: float) -> void:
	velocity.x = speed
	if velocity.x > 0:
		$Polygon2D.scale.x = 1
	else:
		$Polygon2D.scale.x = -1
	move_and_slide()
