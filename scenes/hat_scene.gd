extends Area2D

signal picked_up

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Check it's Glorbert (CharacterBody2D)
	if body is CharacterBody2D:
		picked_up.emit()
		queue_free()  # remove the hat from the scene
