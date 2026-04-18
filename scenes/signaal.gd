extends CharacterBody2D

var nurk = 0
var kiirus = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity.x = kiirus * sin(nurk)
	velocity.y = kiirus * cos(nurk)
	move_and_slide()
	if is_on_floor():
		queue_free()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("glorbert"):
			collider.take_damage()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
