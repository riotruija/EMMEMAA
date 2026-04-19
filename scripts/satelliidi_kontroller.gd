extends Node

@export var vastane_sateliit: PackedScene

var asendid = [
	Vector2(1450, -350),
	Vector2(2400, -300),
	Vector2(2750, -200),
	Vector2(3500, -250),
	Vector2(4000, -300),
	Vector2(4600, -200),
	Vector2(5400, -400),
	Vector2(6400, -350),
	Vector2(7000, -300),
	Vector2(7600, -400),
	Vector2(8000, -300),
	Vector2(8500, -350),
	Vector2(8850, -400)
]

var nurgad = [
	0,
	-PI/8,
	PI/8,
	-PI/8,
	0,
	PI/8,
	0,
	-PI/8,
	0,
	PI/8,
	-PI/8,
	0,
	-PI/8
]

var varvid = [
	2,
	1,
	0,
	1,
	2,
	0,
	2,
	1,
	2,
	0,
	1,
	2,
	1
]


func tee_vastane(asend: Vector2, nurk, intervall, varv, signaali_kiirus, i):
	var vastane = vastane_sateliit.instantiate()
	vastane.position = asend
	vastane.nurk = nurk
	vastane.intervall = intervall
	vastane.signaali_kiirus = signaali_kiirus
	vastane.varv = varv
	vastane.varvi()
	vastane.indeks = i
	add_child(vastane)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	for i in range(len(asendid)):
		if GameState.sat_mask[i]:
			tee_vastane(asendid[i], nurgad[i], rng.randf_range(0.5, 2.0), varvid[i], 1000, i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
