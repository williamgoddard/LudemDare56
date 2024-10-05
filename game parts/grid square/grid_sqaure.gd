class_name GridSquare extends Area2D

@export var grid_pos : Vector2 = Vector2(-1, -1)

@export var room : Room = null:
	set(value):
		if value != null:
			if room == null:
				room = value
				room.reparent(self)
				room.position = Vector2(0,0)
			else:
				room.position = Vector2(0,0)
		elif value == null:
			room = null
