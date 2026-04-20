extends Node2D

var BULLET_SPEED = 2000
@export var bullet_scene: PackedScene
@onready var gun_shoot_player = $"../../Camera2D/Sounds/Gun_shoot"
var viimane_lask = Time.get_ticks_msec() / 1000.0
var praegune_lask
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_bullet(flipped: bool):
	praegune_lask = Time.get_ticks_msec() / 1000.0
	var bullet = bullet_scene.instantiate()
	if flipped:
		bullet.speed = -BULLET_SPEED
		
	else:
		bullet.speed = BULLET_SPEED
		
	if praegune_lask - viimane_lask < 0.1:
		viimane_lask = praegune_lask
		return
	else:
		gun_shoot_player.pitch_scale = randf_range(1.0, 1.6)
		gun_shoot_player.play()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
	viimane_lask = praegune_lask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
