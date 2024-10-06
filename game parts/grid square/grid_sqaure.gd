class_name GridSquare extends Area2D

@export var grid_pos : Vector2 = Vector2(-1, -1)

@export var room : Room = null:
	set(value):
		if value != null:
			if room == null:
				room = value
				room.reparent(self)
				room.room_been_moved.connect(_room_been_moved)
		elif value == null:
			if room != null:
				room.room_been_moved.disconnect(_room_been_moved)
			room = null

func _room_been_moved():
	room = null
