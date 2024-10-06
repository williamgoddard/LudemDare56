class_name RoomGrid extends Node2D

const GRID_SQAURE = preload("res://game parts/grid square/grid_sqaure.tscn")
const ROOM = preload("res://game parts/room/room.tscn")

const MAX_WIDTH := 10
const MAX_HEIGHT := 10

var is_ready := false

@export var dimensions := Vector2(1,1):
	set(value):
		dimensions = Vector2(floor(clamp(value.x, 1, MAX_WIDTH)), floor(clamp(value.y, 1, MAX_HEIGHT)))
		if is_ready:
			generate_grid()

var grid := []

func _ready():
	generate_grid()
	is_ready = true

func _character_moved_room(grid_square: GridSquare, character: GameCharacter, direction):
	var direction_encodings = {
		Global.Direction.RIGHT: Vector2(1, 0),
		Global.Direction.LEFT: Vector2(-1, 0),
		Global.Direction.UP: Vector2(0, -1),
		Global.Direction.DOWN: Vector2(0, 1)
	}
	var grid_position = grid_square.grid_pos
	var target_grid_position = grid_position + direction_encodings[direction]
	if not is_valid_position(target_grid_position):
		return
	var target_grid_square = grid[target_grid_position.x][target_grid_position.y]
	if target_grid_square == null or target_grid_square.room == null:
		return
	grid_square.room.remove_character(character)
	target_grid_square.room.add_character(character)
	character.process_reparent()

func generate_grid():
	grid = []
	remove_old_grid_squares()
	for i in dimensions.x:
		grid.append([])
		for j in dimensions.y:
			var grid_square = GRID_SQAURE.instantiate()
			grid_square.position = Vector2(i*128, j*128)
			grid_square.grid_pos = Vector2(i, j)
			add_child(grid_square)
			grid_square.character_left_room.connect(_character_moved_room)
			grid[i].append(grid_square)

func remove_old_grid_squares():
	for node in get_children():
		if node is GridSquare:
			node.queue_free()

func find_shortest_path(start_square : GridSquare, end_square : GridSquare):
	var start_pos = start_square.grid_pos
	var end_pos = end_square.grid_pos
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 1)]
	var direction_decodings = {
		Vector2(1, 0) : Global.Direction.RIGHT,
		Vector2(-1, 0) : Global.Direction.LEFT,
		Vector2(0, -1) : Global.Direction.UP,
		Vector2(0, 1) : Global.Direction.DOWN
	}
	
	if start_pos == null or end_pos == null or start_square.room == null or end_square.room == null:
		return []
	
	var queue = []
	var came_from = {}
	queue.append(start_pos)
	came_from[start_pos] = null
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current == end_pos:
				var path = []
				while current != null and came_from[current] != null:
					var next = came_from[current]
					var direction_vector : Vector2 = current - next
					path.insert(0, direction_decodings[direction_vector])
					current = next
				return path
		
		for direction in directions:
			var neighbor = current + direction
			if is_valid_position(neighbor) and neighbor not in came_from:
				var neighbor_square = grid[neighbor.x][neighbor.y]
				if neighbor_square == null or neighbor_square.room == null:
					continue
				elif direction.x == 1:
					if !start_square.room.right_door:
						continue
					elif !neighbor_square.room.left_door:
						continue
				elif direction.x == -1:
					if !start_square.room.left_door:
						continue
					elif !neighbor_square.room.right_door:
						continue
				elif direction.y == -1:
					if !start_square.room.room_type == Global.RoomType.LADDER:
						continue
				elif direction.y == 1:
					if !neighbor_square.room.room_type == Global.RoomType.LADDER:
						continue
				queue.append(neighbor)
				came_from[neighbor] = current
	
	#no path found
	return []

func is_valid_position(pos):
	return pos.x >= 0 and pos.x < dimensions.x and pos.y >= 0 and pos.y < dimensions.y
