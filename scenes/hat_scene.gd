extends Area2D

signal picked_up

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("glorbert") and not body.has_hat:
		picked_up.emit()
		queue_free()
