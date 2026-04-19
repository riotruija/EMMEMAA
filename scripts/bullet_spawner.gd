extends Node2D

var BULLET_SPEED = 2000
@export var bullet_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_bullet(flipped: bool):
	var bullet = bullet_scene.instantiate()
	if flipped:
		bullet.speed = -BULLET_SPEED
		
	else:
		bullet.speed = BULLET_SPEED
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
