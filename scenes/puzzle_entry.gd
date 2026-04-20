extends Area2D

@onready var prompt: Label = $Prompt

var player_inside: bool = false

func _ready() -> void:
	prompt.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("glorbert"):
		player_inside = true
		prompt.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("glorbert"):
		player_inside = false
		prompt.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event is InputEventKey and event.pressed and event.keycode == KEY_E:
		get_tree().change_scene_to_file("res://scenes/pusle.tscn")
