extends CharacterBody2D

var AMPLITUUD = 30.0
var SAGEDUS = 3.0
var _t = 0

func _physics_process(delta: float) -> void:
	# paneb vonkuma
	velocity.x = AMPLITUUD * cos(SAGEDUS * _t)
	_t += delta
	move_and_slide()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
