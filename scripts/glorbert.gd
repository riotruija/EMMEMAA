extends CharacterBody2D


@export var glorbert: CharacterBody2D
@export var maapind: Node2D
var maapinna_pind: StaticBody2D

var SAAPAD_YLES = 750
var SAAPAD_EDASITAGASI = 400
var MAX_KIIRUS_YLES = 400
var GRAVITATSIOON = 1500
var HOORDUMINE = 1000

var hoiab_paremale: bool = false
var hoiab_vasakule: bool = false
var double_jump_available: bool = true

@onready var glorbert_sprite_tavaline = $Glorbert_sprite
@onready var glorbert_sprite_foolium = $Glorbert_sprite_foolium
@onready var glorbert_sprite_gun = $Glorbert_sprite_gun
@onready var glorbert_sprite_foolium_gun = $Glorbert_sprite_foolium_gun
@onready var sprite = glorbert_sprite_tavaline

# === HELID ==
@onready var landing_player = $"../Camera2D/Sounds/Landing"
@onready var jumping_player = $"../Camera2D/Sounds/Jumping"
@onready var running_player = $"../Camera2D/Sounds/Running"
@onready var hurt_player = $"../Camera2D/Sounds/Hurt"
@onready var hat_pickup_player = $"../Camera2D/Sounds/Hat_pickup"
@onready var gun_pickup_player = $"../Camera2D/Sounds/Gun_pickup"
var on_jooksmas = false
# === HAT SYSTEM ===
@export var hat_scene: PackedScene
@export var spawn_points: Node2D  # drag your HatSpawnPoints node here in the inspector
var has_hat: bool = false
var current_hat: Node = null
var used_spawn_points: Array = []

# === GUN SYSTEM ===
@export var gun_scene: PackedScene
@export var gun_spawn_points: Node2D
const GUN_DURATION := 10.0  # seconds
var gun_time_left := 0.0
var used_gun_spawn_points: Array = []
@onready var gun_timer_bar = $"../CanvasLayer/GunTimerBar"
@onready var gun_timer_fill = $"../CanvasLayer/GunTimerBar/Fill"
var has_gun: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glorbert_sprite_foolium.hide()
	glorbert_sprite_gun.hide()
	glorbert_sprite_foolium_gun.hide()
	glorbert_sprite_tavaline.show()
	maapinna_pind = maapind.get_node("StaticBody2D")
	spawn_hat()
	spawn_all_guns()  # ← add this
	gun_timer_bar.hide()

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
	
	if event.is_action("fire") and event.is_pressed() and has_gun:
		fire()

func fire() -> void:
	$BulletSpawner.spawn_bullet(sprite.flip_h)
	
	
func take_damage():
	hurt_player.play()
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
	if Input.is_action_just_pressed("up") and (glorbert.is_on_floor() or double_jump_available):
		if !glorbert.is_on_floor():
			double_jump_available = false
		print("kargab")
		velocity.y = -SAAPAD_YLES
		jumping_player.play()
		
	if sprite.animation == "running":
		running_player.play()
	else:
		running_player.stop()
	if not is_on_floor():
		if velocity.y < 0:
			sprite.play("falling")
		if velocity.y >= 0:
			sprite.play("jumping")
	if glorbert.is_on_floor() and not double_jump_available:
		double_jump_available = true
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
	if has_gun:
		gun_time_left -= delta
		update_gun_timer_bar()
		if gun_time_left <= 0:
			lose_gun()

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
	
	# Filter out already-used spawn points
	var unused = valid.filter(func(p): return p not in used_spawn_points)
	
	# If all have been used, reset and use any (or just give up — your choice)
	if unused.is_empty():
		print("All spawn points used — no more hats!")
		return
	
	var chosen = unused[randi() % unused.size()]
	used_spawn_points.append(chosen)
	
	var hat = hat_scene.instantiate()
	spawn_points.add_child(hat)            # ← changed
	hat.global_position = chosen.global_position  # set position AFTER adding
	
	hat.picked_up.connect(_on_hat_picked_up)
	current_hat = hat

func _on_hat_picked_up() -> void:
	has_hat = true
	current_hat = null
	update_sprite()
	hat_pickup_player.play()
	print("Picked up the hat!")

func lose_hat() -> void:
	has_hat = false
	current_hat = null
	update_sprite()
	print("Lost the hat!")
	spawn_hat()

func spawn_all_guns() -> void:
	print("=== spawn_all_guns called ===")
	if gun_spawn_points == null:
		print("  gun_spawn_points is null!")
		return
	if gun_scene == null:
		print("  gun_scene is null!")
		return
	var children = gun_spawn_points.get_children()
	print("  found ", children.size(), " gun spawn points")
	for point in children:
		print("  spawning at ", point.name)
		spawn_gun_at(point)

func spawn_gun_at(point: Node2D) -> void:
	var gun = gun_scene.instantiate()
	gun_spawn_points.add_child(gun)
	gun.global_position = point.global_position
	gun.picked_up.connect(_on_gun_picked_up.bind(point))

func _on_gun_picked_up(point: Node2D) -> void:
	used_gun_spawn_points.append(point)
	gun_pickup_player.play()
	pick_up_gun()

func pick_up_gun() -> void:
	has_gun = true
	gun_time_left = GUN_DURATION  # reset to full whether new pickup or refill
	gun_timer_bar.show()
	update_gun_timer_bar()
	update_sprite()

func lose_gun() -> void:
	has_gun = false
	gun_time_left = 0
	gun_timer_bar.hide()
	update_sprite()

func update_gun_timer_bar() -> void:
	# Shrink from both sides — the fill goes from 100% width to 0%
	var ratio = clamp(gun_time_left / GUN_DURATION, 0.0, 1.0)
	gun_timer_fill.anchor_left = 0.5 - (ratio * 0.5)
	gun_timer_fill.anchor_right = 0.5 + (ratio * 0.5)
