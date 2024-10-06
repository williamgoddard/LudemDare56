class_name Room extends Area2D

signal room_been_moved()

@export var left_door := false
@export var right_door := false
@export var room_type := Global.RoomType.DEFAULT

var hover := false
var selected := false
var mouse_offset := Vector2(0,0)
var overlap_areas = []

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

func find_closest_overlap_grid_square():
	var best_distance : float = 999999999
	var best_grid_square : GridSquare = null
	for grid_square in overlap_areas:
		var distance = global_position.distance_to(grid_square.global_position)
		if distance < best_distance:
			best_distance = distance
			best_grid_square = grid_square
	return best_grid_square
