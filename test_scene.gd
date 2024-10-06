extends Node2D

const ROOM = preload("res://game parts/room/room.tscn")
const CHARACTER = preload("res://game parts/character/character.tscn")

@onready var room_grid = $RoomGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	var room
	
	room = ROOM.instantiate()
	room.left_door = true
	room.right_door = true
	room.room_type = Global.RoomType.LADDER
	add_child(room)
	room_grid.grid[0][1].room = room
	room.position = Vector2(0,0)
	
	room = ROOM.instantiate()
	room.left_door = true
	room.right_door = true
	room.room_type = Global.RoomType.LADDER
	add_child(room)
	room_grid.grid[0][2].room = room
	room.position = Vector2(0,0)
	
	room = ROOM.instantiate()
	room.left_door = true
	room.right_door = true
	room.room_type = Global.RoomType.LADDER
	add_child(room)
	room_grid.grid[1][2].room = room
	room.position = Vector2(0,0)
	
	room = ROOM.instantiate()
	room.left_door = true
	room.right_door = true
	room.room_type = Global.RoomType.LADDER
	add_child(room)
	room_grid.grid[2][2].room = room
	room.position = Vector2(0,0)
	
	var character = CHARACTER.instantiate()
	add_child(character)
	room_grid.grid[0][1].room.add_character(character)
	var path = room_grid.find_shortest_path(room_grid.grid[0][1], room_grid.grid[2][2])
	character.position = Vector2(0,0)
	character.execute_path(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
