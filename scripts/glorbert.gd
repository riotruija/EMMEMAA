extends CharacterBody2D


@export var glorbert: CharacterBody2D
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

@onready var glorbert_sprite_tavaline = $Glorbert_sprite
@onready var glorbert_sprite_foolium = $Glorbert_sprite_foolium
@onready var glorbert_sprite_gun = $Glorbert_sprite_gun
@onready var glorbert_sprite_foolium_gun = $Glorbert_sprite_foolium_gun
@onready var sprite = glorbert_sprite_tavaline


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glorbert_sprite_foolium.hide()
	glorbert_sprite_gun.hide()
	glorbert_sprite_foolium_gun.hide()
	glorbert_sprite_tavaline.show()
	glorbert_sprite_foolium_gun.hide()
	glorbert_sprite_gun.hide()
	maapinna_pind = maapind.get_node("StaticBody2D")
	
func _unhandled_key_input(event: InputEvent) -> void:		
	if event.is_action("left") and event.is_pressed():
		hoiab_vasakule = true
		sprite.flip_h = true
		
	if event.is_action("left") and event.is_released():
		hoiab_vasakule = false

		
	if event.is_action("right") and event.is_pressed():
		hoiab_paremale = true
		sprite.flip_h = false
		
	if event.is_action("right") and event.is_released():
		hoiab_paremale = false
	
func take_damage():
	$"../CanvasLayer/ColorRect".flash()

func _physics_process(delta: float) -> void:
	if not glorbert.is_on_floor():
		glorbert.velocity.y += GRAVITATSIOON * delta
	if hoiab_paremale and not hoiab_vasakule:
		glorbert.velocity.x = SAAPAD_EDASITAGASI
	elif hoiab_vasakule and not hoiab_paremale:
		glorbert.velocity.x = -SAAPAD_EDASITAGASI
	else:
		glorbert.velocity.x = move_toward(glorbert.velocity.x, 0, HOORDUMINE * delta)
	if Input.is_action_just_pressed("up") and glorbert.is_on_floor():
		print("kargab")
		velocity.y = -SAAPAD_YLES
	if not is_on_floor():
		if velocity.y < 0:
			sprite.play("falling")
		if velocity.y >= 0:
			sprite.play("jumping")
	else:
		if velocity.x > 10:
			sprite.play("running")
		elif velocity.x < -10:
			sprite.play("running")
		else:
			sprite.play("idle")
	glorbert.move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
