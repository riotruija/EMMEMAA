extends Area2D

var KIIRUS = 100
@onready var sound_player: AudioStreamPlayer2D = $Sound_player

func _physics_process(delta: float):
	position.x -= KIIRUS * delta

		
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("tekkis suur laine")
	sound_player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sound_player.pitch_scale = randf_range(1.0, 1.6)
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("glorbert"):
		body.die()
	pass # Replace with function body.
