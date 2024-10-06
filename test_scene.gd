extends Node2D

const ROOM = preload("res://game parts/room/room.tscn")

@onready var room_grid = $RoomGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	var room
	
	room = ROOM.instantiate()
	add_child(room)
	room_grid.grid[0][1].room = room
	room.position = Vector2(0,0)
	
	room = ROOM.instantiate()
	add_child(room)
	room_grid.grid[0][2].room = room
	room.position = Vector2(0,0)
	
	room = ROOM.instantiate()
	add_child(room)
	room_grid.grid[4][1].room = room
	room.position = Vector2(0,0)
	
	room = ROOM.instantiate()
	add_child(room)
	room_grid.grid[4][2].room = room
	room.position = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
