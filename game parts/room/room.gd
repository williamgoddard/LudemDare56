class_name Room extends Area2D

signal room_been_moved()
signal character_left_room()

@onready var room_border = $RoomBorder
@onready var room_background = $RoomBackground

const BORDER = preload("res://game parts/room/sprites/border.png")
const BORDER_BOTH = preload("res://game parts/room/sprites/border_both.png")
const BORDER_LEFT = preload("res://game parts/room/sprites/border_left.png")
const BORDER_RIGHT = preload("res://game parts/room/sprites/border_right.png")

const DEFAULT_1 = preload("res://game parts/room/sprites/default_1.png")
const DEFAULT_2 = preload("res://game parts/room/sprites/default_2.png")
const DEFAULT_3 = preload("res://game parts/room/sprites/default_3.png")
const BEDROOM = preload("res://game parts/room/sprites/bedroom.png")
const BATHROOM = preload("res://game parts/room/sprites/bathroom.png")
const KITCHEN = preload("res://game parts/room/sprites/kitchen.png")
const LADDER = preload("res://game parts/room/sprites/ladder.png")

@export var left_door := false:
	set(value):
		left_door = value
		if is_ready:
			update_border()
@export var right_door := false:
	set(value):
		right_door = value
		if is_ready:
			update_border()
@export var room_type := Global.RoomType.DEFAULT:
	set(value):
		room_type = value
		if is_ready:
			update_background()

var hover := false
var selected := false
var mouse_offset := Vector2(0,0)
var overlap_areas = []
var characters = []
var is_ready = false

func _ready():
	update_border()
	update_background()
	is_ready = true

func _process(delta):
	if hover and Input.is_action_just_pressed("mouse_select") and not Global.dragging:
		selected = true
		Global.dragging = true
		mouse_offset = get_global_mouse_position() - global_position
	if selected and Input.is_action_just_released("mouse_select"):
		selected = false
		Global.dragging = false
		var grid_square : GridSquare = find_closest_overlap_grid_square()
		if grid_square != null and grid_square.room == null:
			room_been_moved.emit()
			grid_square.room = self
		position = Vector2(0,0)
	if selected:
		global_position = get_global_mouse_position() - mouse_offset

func _on_mouse_entered():
	hover = true

func _on_mouse_exited():
	hover = false

func _on_area_entered(area):
	overlap_areas.append(area)

func _on_area_exited(area):
	overlap_areas.erase(area)

func _on_character_leave(character, direction):
	character_left_room.emit(character, direction)

func find_closest_overlap_grid_square():
	var best_distance : float = 999999999
	var best_grid_square : GridSquare = null
	for grid_square in overlap_areas:
		var distance = global_position.distance_to(grid_square.global_position)
		if distance < best_distance:
			best_distance = distance
			best_grid_square = grid_square
	return best_grid_square

func add_character(character: GameCharacter):
	character.reparent(self)
	characters.append(character)
	character.movement_finished.connect(_on_character_leave)

func remove_character(character: GameCharacter):
	characters.erase(character)
	character.movement_finished.disconnect(_on_character_leave)

func update_border():
	if not left_door and not right_door:
		room_border.texture = BORDER
	elif left_door and not right_door:
		room_border.texture = BORDER_LEFT
	elif not left_door and right_door:
		room_border.texture = BORDER_RIGHT
	else:
		room_border.texture = BORDER_BOTH

func update_background():
	match room_type:
		Global.RoomType.DEFAULT:
			room_background.texture = [DEFAULT_1, DEFAULT_2, DEFAULT_3][randi_range(0,2)]
		Global.RoomType.LADDER:
			room_background.texture = LADDER
		Global.RoomType.BATHROOM:
			room_background.texture = BATHROOM
		Global.RoomType.BEDROOM:
			room_background.texture = BEDROOM
		Global.RoomType.KITCHEN:
			room_background.texture = KITCHEN
