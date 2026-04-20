extends CharacterBody2D
@onready var sprite = $Polygon2D
var speed = 1000
var lifetime = 0.7

func _physics_process(delta: float) -> void:
	velocity.x = speed
	if velocity.x > 0:
		$Polygon2D.scale.x = 2
	else:
		$Polygon2D.scale.x = -2
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("sateliit"):
			collider.kill()
			queue_free()
	
	lifetime -= delta
	if (lifetime < 0):
		queue_free()
