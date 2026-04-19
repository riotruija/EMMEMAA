extends Node2D

@onready var nupp_player: AudioStreamPlayer2D = $Nupp_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_main_menu_pressed() -> void:
	nupp_player.play()
	await nupp_player.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_pressed() -> void:
	nupp_player.play()
	await nupp_player.finished
	print("Exit pressed")
	get_tree().quit(0)
