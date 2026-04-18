extends Camera2D

@export var target: Node2D
@export var fixed_y: float = 0.0
@export var x_offset: float = 500.0  # positive = character sits left of center
@onready var muusika_mangija = $Music_player

var muusika = [
	preload("res://music/muusika_main_intro.mp3"),
	preload("res://music/muusika_main_loop.mp3")
]
var mitmes_lugu = 0

func _ready() -> void:
	muusika_mangija.set_stream(muusika[mitmes_lugu])
	muusika_mangija.play()
	muusika_mangija.finished.connect(muusika_algus_labi)

func muusika_algus_labi() -> void:
	mitmes_lugu = 1
	muusika_mangija.set_stream(muusika[mitmes_lugu])
	muusika_mangija.play()
	
func _process(_delta: float) -> void:
	if target:
		position.x = target.global_position.x + x_offset
		position.y = fixed_y
