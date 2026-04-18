extends Camera2D

@export var target: Node2D
@export var fixed_y: float = 0.0
@export var x_offset: float = 150.0  # positive = character sits left of center

func _process(_delta: float) -> void:
	if target:
		position.x = target.global_position.x + x_offset
		position.y = fixed_y
