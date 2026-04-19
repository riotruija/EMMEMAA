extends Node2D

@onready var run_box: Sprite2D = $RunBox
@onready var arrow_down: Sprite2D = $ArrowDown
@onready var try_box: Sprite2D = $TryBox
@onready var try_text: Label = $TryAgain
@onready var try_zone: Area2D = $TryAgainZone
@onready var run_label: Label = $RunLabel

var player_in_try_zone: bool = false

func _ready() -> void:
	try_zone.body_entered.connect(_on_try_zone_entered)
	try_zone.body_exited.connect(_on_try_zone_exited)
	update_visibility()

func _on_try_zone_entered(body: Node) -> void:
	if body.is_in_group("glorbert"):
		player_in_try_zone = true
		update_visibility()

func _on_try_zone_exited(body: Node) -> void:
	if body.is_in_group("glorbert"):
		player_in_try_zone = false
		update_visibility()

func update_visibility() -> void:
	run_box.visible = GameState.puzzle_won
	run_label.visible = GameState.puzzle_won
	arrow_down.visible = not GameState.puzzle_won
	try_box.visible = player_in_try_zone and not GameState.puzzle_won
	try_text.visible = player_in_try_zone and not GameState.puzzle_won
