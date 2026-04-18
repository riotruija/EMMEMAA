extends Node2D

const WIDTH := 8
const HEIGHT := 6
const CELL_SIZE := 64

var player_pos := Vector2i(0, 0)
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
	player_pos = Vector2i(0, 0)
	path.append(player_pos)
	grid[0][0]["filled"] = true

	# example: block some tiles (optional)
	grid[2][3]["blocked"] = true
	grid[3][3]["blocked"] = true


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
	queue_redraw()


func is_inside(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < WIDTH and pos.y >= 0 and pos.y < HEIGHT


func _draw():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var rect = Rect2(
				x * CELL_SIZE,
				y * CELL_SIZE,
				CELL_SIZE,
				CELL_SIZE
			)

			var cell = grid[y][x]

			if cell["blocked"]:
				draw_rect(rect, Color.DARK_GRAY)
			elif cell["filled"]:
				draw_rect(rect, Color.GREEN)
			else:
				draw_rect(rect, Color(0.2, 0.2, 0.2))

			# grid lines
			draw_rect(rect, Color.BLACK, false, 2)

	# draw player
	var player_rect = Rect2(
		player_pos.x * CELL_SIZE,
		player_pos.y * CELL_SIZE,
		CELL_SIZE,
		CELL_SIZE
	)
	draw_rect(player_rect, Color.RED)
