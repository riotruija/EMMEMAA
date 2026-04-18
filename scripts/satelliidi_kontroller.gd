extends Node

@export var vastane_sateliit: PackedScene

func tee_vastane(asend: Vector2):
	var vastane = vastane_sateliit.instantiate()
	vastane.position = asend
	add_child(vastane)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)
	pass # Replace with function body.

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("down") and event.is_pressed():
		tee_vastane(Vector2(100, -200))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
