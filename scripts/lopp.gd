extends Area2D

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D and GameState.puzzle_won == true:
		end_level()
		
func end_level() -> void:
	get_tree().change_scene_to_file("res://scenes/end.tscn")
