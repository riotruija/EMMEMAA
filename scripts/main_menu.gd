extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var options: Panel = $Options


var muusika = [
	preload("res://music/main_menu_music_intro.mp3"),
	preload("res://music/main_menu_music_looping.mp3")
]

var mitmes_lugu = 0

func _ready() -> void:
	audio_stream_player_2d.stream = muusika[mitmes_lugu]
	audio_stream_player_2d.play()
	audio_stream_player_2d.finished.connect(music_finished)
	options.visible = false
	main_buttons.visible = true

func music_finished() -> void:
	mitmes_lugu = 1
	audio_stream_player_2d.stream = muusika[mitmes_lugu]
	audio_stream_player_2d.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/earth.tscn")
	pass
	
func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	
func _on_exit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit(0)
	
func _on_options_back_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
