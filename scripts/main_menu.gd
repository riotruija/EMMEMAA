extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var options: Panel = $Options

var muusika = [
	preload("res://music/main_menu_music.mp3")
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Options node: ", options)
	print("Buttons node: ", main_buttons)
	options.visible = false
	main_buttons.visible = true
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("Start pressed")
	# get_tree().change_scene_to_file("res://scenes/earth.tscn") //Vahetab siis kui valmis
	pass # Alustab pelu


func _on_options_pressed() -> void:
	print("Options pressed")
	main_buttons.visible = false
	options.visible = true
	pass # Viib optionitesse


func _on_exit_pressed() -> void:
	print("Exit pressed")
	get_tree().quit(0) # Väljub


func _on_options_back_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
