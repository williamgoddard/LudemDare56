class_name GridSquare extends Area2D

signal character_left_room(square: GridSquare, character: GameCharacter, direction: Global.Direction)

@export var grid_pos : Vector2 = Vector2(-1, -1)

@export var room : Room = null:
	set(value):
		if value != null:
			if room == null:
				room = value
				room.reparent(self)
				room.room_been_moved.connect(_room_been_moved)
				room.character_left_room.connect(_character_left_room)
		elif value == null:
			if room != null:
				room.room_been_moved.disconnect(_room_been_moved)
				room.character_left_room.disconnect(_character_left_room)
			room = null

func _room_been_moved():
	room = null

func _character_left_room(character, direction):
	character_left_room.emit(self, character, direction)
