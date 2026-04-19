extends Node

var next_player_position: Vector2 = Vector2.ZERO
var puzzle_won: bool = false
var puzzle_attempted: bool = false

# === CHECKPOINT ===
var checkpoint_active: bool = false
var checkpoint_position: Vector2 = Vector2(8410, 30)
