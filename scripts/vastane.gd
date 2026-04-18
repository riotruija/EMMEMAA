extends CharacterBody2D

# satelliidi enda liikumise andmed
var AMPLITUUD = 30.0
var SAGEDUS = 3.0
var _t = 0

@export var signaal: PackedScene

# satelliidi projectilei andmed
var nurk = 0
# iga mitme s tagant tulistab
var intervall = 1.0
# kui kiire signaali tulistab
var signaali_kiirus = 1000
var tulistamiseni = intervall

func _physics_process(delta: float) -> void:
	# paneb vonkuma
	velocity.x = AMPLITUUD * cos(SAGEDUS * _t)
	_t += delta
	tulistamiseni -= delta
	if (tulistamiseni <= 0):
		tulistamiseni = intervall
		shoot()
	
	move_and_slide()

func shoot() -> void:
	var s = signaal.instantiate()
	s.kiirus = signaali_kiirus
	s.nurk = nurk
	add_child(s)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
