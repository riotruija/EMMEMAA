extends Node

@export var vastane_sateliit: PackedScene

func tee_vastane(asend: Vector2, nurk, intervall, signaali_kiirus):
	var vastane = vastane_sateliit.instantiate()
	vastane.position = asend
	vastane.nurk = nurk
	vastane.intervall = intervall
	vastane.signaali_kiirus = signaali_kiirus
	add_child(vastane)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)
	pass # Replace with function body.

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("down") and event.is_pressed():
		tee_vastane(Vector2(250, -200), PI/8, 1.0, 1000)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
