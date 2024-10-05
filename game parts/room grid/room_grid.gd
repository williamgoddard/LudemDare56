class_name RoomGrid extends Node2D

const GRID_SQAURE = preload("res://game parts/grid square/grid_sqaure.tscn")

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

func generate_grid():
	grid = []
	remove_old_grid_squares()
	for i in dimensions.x:
		grid.append([])
		for j in dimensions.y:
			var grid_square = GRID_SQAURE.instantiate()
			grid_square.position = Vector2(i*128, j*128)
			add_child(grid_square)
			grid[i].append(grid_square)

func remove_old_grid_squares():
	for node in get_children():
		if node is GridSquare:
			node.queue_free()
