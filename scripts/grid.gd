extends Node2D

const WIDTH := 8
const HEIGHT := 6

# === TIMER CONFIG ===
const TIME_LIMIT := 45.0  # seconds — change this to adjust difficulty
const TIMEOUT_SCENE := "res://earth.tscn"  # change to your target scene

# === TILEMAP ===
@onready var tilemap := $TileMapLayer
@onready var timer_label := $UI/TimerLabel
@onready var instruction_label := $UI/InstructionLabel

# === TILE IDs (CHANGE THESE TO MATCH YOUR TILESET) ===
const SOURCE_ID := 9

const TILE_EMPTY := Vector2i(0, 0)
const TILE_PATH := Vector2i(1, 0)
const TILE_BLOCKED := Vector2i(2, 1)
const TILE_PLAYER := Vector2i(0, 1)

# === GAME STATE ===
var player_pos := Vector2i(0, 5)
var path: Array[Vector2i] = []
var grid := []
var time_left := TIME_LIMIT
var game_over := false


func _ready():
	# create grid
	for y in range(HEIGHT):
		grid.append([])
		for x in range(WIDTH):
			grid[y].append({
				"filled": false,
				"blocked": false
			})

	# starting position
	player_pos = Vector2i(0, 4)
	path.append(player_pos)
	grid[4][0]["filled"] = true

	# example blocked tiles
	grid[0][0]["blocked"] = true
	grid[0][1]["blocked"] = true
	grid[1][0]["blocked"] = true
	grid[2][0]["blocked"] = true
	grid[3][0]["blocked"] = true
	grid[5][0]["blocked"] = true
	
	grid[5][1]["blocked"] = true
	grid[5][2]["blocked"] = true
	grid[5][3]["blocked"] = true
	grid[5][7]["blocked"] = true

	grid[3][7]["blocked"] = true
	grid[4][7]["blocked"] = true
	
	grid[0][6]["blocked"] = true
	grid[0][7]["blocked"] = true
	
	grid[1][6]["blocked"] = true
	grid[1][7]["blocked"] = true
	
	grid[1][3]["blocked"] = true
	grid[1][4]["blocked"] = true
	
	grid[2][4]["blocked"] = true
	grid[3][4]["blocked"] = true
	
	instruction_label.text = "Fill all!"
	
	# --- instruction text ---
	var label = $UI/InstructionLabel

	# initial state (centered, small, invisible)
	label.modulate.a = 0.0
	label.scale = Vector2(1, 1)

	var tween = create_tween()

	# use smooth easing (no bounce / no overshoot)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# fade in + grow to normal size
	tween.parallel().tween_property(label, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)

	# stay visible
	tween.tween_interval(10)

	# fade out + shrink back
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.1)
	tween.parallel().tween_property(label, "scale", Vector2(0.9, 0.9), 0.5)
	# --- text move end ---
	
	update_timer_label()
	
	update_tiles()
	center_grid()

func _process(delta):
	if game_over:
		return
	time_left -= delta
	update_timer_label()
	if time_left <= 0:
		time_left = 0
		update_timer_label()
		game_over = true
		get_tree().change_scene_to_file("res://scenes/earth.tscn")

func update_timer_label():
	timer_label.text = "Time: %d" % ceil(time_left)

func _input(event):
	if game_over:
		return
	if event.is_action_pressed("up"):
		move(Vector2i(0, -1))
	elif event.is_action_pressed("down"):
		move(Vector2i(0, 1))
	elif event.is_action_pressed("left"):
		move(Vector2i(-1, 0))
	elif event.is_action_pressed("right"):
		move(Vector2i(1, 0))


func move(dir: Vector2i):
	var new_pos = player_pos + dir

	if not is_inside(new_pos):
		return

	if grid[new_pos.y][new_pos.x]["blocked"]:
		return

	# CASE 1: forward
	if not path.has(new_pos):
		path.append(new_pos)
		grid[new_pos.y][new_pos.x]["filled"] = true

	# CASE 2: backtrack
	elif path.size() > 1 and new_pos == path[path.size() - 2]:
		var last = path.pop_back()
		grid[last.y][last.x]["filled"] = false

	# CASE 3: loop → cut path
	else:
		var index = path.find(new_pos)
		if index != -1:
			for i in range(path.size() - 1, index, -1):
				var removed = path.pop_back()
				grid[removed.y][removed.x]["filled"] = false

	player_pos = new_pos
	update_tiles()
	check_win()


func is_inside(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < WIDTH and pos.y >= 0 and pos.y < HEIGHT


func update_tiles():
	tilemap.clear()

	for y in range(HEIGHT):
		for x in range(WIDTH):
			var pos = Vector2i(x, y)
			var cell = grid[y][x]

			if cell["blocked"]:
				tilemap.set_cell(pos, SOURCE_ID, TILE_BLOCKED)
			elif cell["filled"]:
				tilemap.set_cell(pos, SOURCE_ID, TILE_PATH)
			else:
				tilemap.set_cell(pos, SOURCE_ID, TILE_EMPTY)

	# draw player (overwrites tile visually)
	tilemap.set_cell(player_pos, SOURCE_ID, TILE_PLAYER)

func center_grid():
	var tile_size = Vector2(tilemap.tile_set.tile_size) * tilemap.scale
	var grid_pixel_size = Vector2(WIDTH * tile_size.x, HEIGHT * tile_size.y)

	tilemap.position = -grid_pixel_size / 2 + tile_size / 2

func check_win() -> void:
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = grid[y][x]

			if cell["blocked"]:
				continue

			if not cell["filled"]:
				return  # not finished yet
	game_over = true
	
	get_tree().change_scene_to_file("res://scenes/earth.tscn")
