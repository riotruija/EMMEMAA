extends ColorRect

@onready var mat := material

var flash_time := 0.15
var timer := 0.0
var max_strength := 0.008

func flash(dir := Vector2(0.5, 0.5)):
	timer = flash_time
	mat.set_shader_parameter("direction", dir.normalized())

func _process(delta):
	if timer > 0:
		timer -= delta
		var t = timer / flash_time
		var strength = max_strength * t
		mat.set_shader_parameter("strength", strength)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
