extends Node2D

const WIDTH := 8
const HEIGHT := 6

# === TILEMAP ===
@onready var tilemap := $TileMapLayer

# === TILE IDs (CHANGE THESE TO MATCH YOUR TILESET) ===
const SOURCE_ID := 0

const TILE_EMPTY := Vector2i(3, 2)
const TILE_PATH := Vector2i(5, 5)
const TILE_BLOCKED := Vector2i(0, 0)
const TILE_PLAYER := Vector2i(5, 7)

# === GAME STATE ===
var player_pos := Vector2i(0, 5)
var path: Array[Vector2i] = []
var grid := []


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

	update_tiles()


func _input(event):
	if event.is_action_pressed("ui_up"):
		move(Vector2i(0, -1))
	elif event.is_action_pressed("ui_down"):
		move(Vector2i(0, 1))
	elif event.is_action_pressed("ui_left"):
		move(Vector2i(-1, 0))
	elif event.is_action_pressed("ui_right"):
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
