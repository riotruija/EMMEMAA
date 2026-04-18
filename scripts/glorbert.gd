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
@onready var glorbert_sprite_gun = $Glorbert_sprite_foolum_gun
@onready var glorbert_sprite_foolium_gun = $Glorbert_sprite_foolum_gun

@onready var sprite = glorbert_sprite_tavaline

# === HAT SYSTEM ===
@export var hat_scene: PackedScene
@export var spawn_points: Node2D  # drag your HatSpawnPoints node here in the inspector
var has_hat: bool = false
var current_hat: Node = null

# === GUN?? ===
var has_gun: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glorbert_sprite_foolium.hide()
	glorbert_sprite_gun.hide()
	glorbert_sprite_foolium_gun.hide()
	glorbert_sprite_tavaline.show()
	maapinna_pind = maapind.get_node("StaticBody2D")
	spawn_hat()

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
	if has_hat:
		lose_hat()
	$"../CanvasLayer/ColorRect".flash()

func update_sprite() -> void:
	# Hide all sprites first
	glorbert_sprite_tavaline.hide()
	glorbert_sprite_foolium.hide()
	glorbert_sprite_gun.hide()
	glorbert_sprite_foolium_gun.hide()
	
	# Pick the right one based on equipment state
	var new_sprite
	if has_hat and has_gun:
		new_sprite = glorbert_sprite_foolium_gun
	elif has_hat:
		new_sprite = glorbert_sprite_foolium
	elif has_gun:
		new_sprite = glorbert_sprite_gun
	else:
		new_sprite = glorbert_sprite_tavaline
	
	# Preserve direction and animation across the swap
	new_sprite.flip_h = sprite.flip_h
	var current_anim = sprite.animation if sprite.is_playing() else "idle"
	new_sprite.show()
	new_sprite.play(current_anim)
	
	# Update the active sprite reference for movement code
	sprite = new_sprite

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

func spawn_hat() -> void:
	if has_hat or current_hat != null:
		return
	if spawn_points == null:
		return
	
	var points = spawn_points.get_children()
	if points.is_empty():
		return
	
	var min_distance = 300.0
	var valid = points.filter(func(p): 
		return p.global_position.distance_to(global_position) > min_distance
	)
	if valid.is_empty():
		valid = points
	
	var chosen = valid[randi() % valid.size()]
	
	var hat = hat_scene.instantiate()
	spawn_points.add_child(hat)            # ← changed
	hat.global_position = chosen.global_position  # set position AFTER adding
	
	hat.picked_up.connect(_on_hat_picked_up)
	current_hat = hat

func _on_hat_picked_up() -> void:
	has_hat = true
	current_hat = null
	update_sprite()
	print("Picked up the hat!")

func lose_hat() -> void:
	has_hat = false
	current_hat = null
	update_sprite()
	print("Lost the hat!")
	spawn_hat()

func pick_up_gun() -> void:
	has_gun = true
	update_sprite()

func lose_gun() -> void:
	has_gun = false
	update_sprite()
