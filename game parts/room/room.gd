class_name Room extends Area2D

@export var left_door := false
@export var right_door := false
@export var room_type := Global.RoomType.DEFAULT

var hover := false
var selected := false
var mouse_offset := Vector2(0,0)

func _process(delta):
	if hover:
		if Input.is_action_just_pressed("mouse_select"):
			selected = true
			Global.dragging = true
			mouse_offset = get_global_mouse_position() - global_position
	if Input.is_action_just_released("mouse_select"):
		selected = false
		Global.dragging = false
	if selected:
		global_position = get_global_mouse_position() - mouse_offset

func _on_mouse_entered():
	if not Global.dragging:
		hover = true

func _on_mouse_exited():
	if not Global.dragging:
		hover = false
