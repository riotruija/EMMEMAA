extends Node2D

@export var glorbert: Node2D
var glorbert_keha: CharacterBody2D
@export var maapind: Node2D
var maapinna_pind: StaticBody2D

var SAAPAD_YLES = 300
var SAAPAD_EDASITAGASI = 150
var MAX_KIIRUS_YLES = 400
var MAX_KIIRUS_EDASITAGASI = 200
var GRAVITATSIOON = 600
var HOORDUMINE = 1000

var hoiab_paremale: bool = false
var hoiab_vasakule: bool = false

@onready var sprite = $glorbert_keha/Glorbert_sprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glorbert_keha = $glorbert_keha
	maapinna_pind = maapind.get_node("StaticBody2D")

func _unhandled_key_input(event: InputEvent) -> void:		
	if event.is_action("left") and event.is_pressed():
		hoiab_vasakule = true
		sprite.flip_h = true
		sprite.play("running")
		
	if event.is_action("left") and event.is_released():
		hoiab_vasakule = false
		sprite.play("idle")
		
	if event.is_action("right") and event.is_pressed():
		hoiab_paremale = true
		sprite.flip_h = false
		sprite.play("running")
		
	if event.is_action("right") and event.is_released():
		hoiab_paremale = false
		sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	if not glorbert_keha.is_on_floor():
		glorbert_keha.velocity.y += GRAVITATSIOON * delta
	
	if hoiab_paremale and not hoiab_vasakule:
		glorbert_keha.velocity.x = SAAPAD_EDASITAGASI
	elif hoiab_vasakule and not hoiab_paremale:
		glorbert_keha.velocity.x = -SAAPAD_EDASITAGASI
	else:
		glorbert_keha.velocity.x = move_toward(glorbert_keha.velocity.x, 0, HOORDUMINE * delta)
	if Input.is_action_just_pressed("up") and glorbert_keha.is_on_floor():
		print("kargab")
		glorbert_keha.velocity.y = -SAAPAD_YLES
	if not glorbert_keha.is_on_floor():
		if glorbert_keha.velocity.y < 0:
			sprite.play("falling")
			
		if glorbert_keha.velocity.y >= 0:
			sprite.play("jumping")
	print(glorbert_keha.is_on_floor())
	"""if glorbert_keha.is_on_floor():
		sprite.play("idle")"""
	
	glorbert_keha.move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
