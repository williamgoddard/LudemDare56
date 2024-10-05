class_name Room extends Area2D

@export var left_door := false
@export var right_door := false
@export var room_type := Global.RoomType.DEFAULT

var hover := false
var selected := false

func _process(delta):
	if hover:
		if Input.is_action_just_pressed("mouse_select"):
			selected = true
			Global.dragging = true
	if Input.is_action_just_released("mouse_select"):
		selected = false
		Global.dragging = false
	if selected:
		global_position = get_global_mouse_position()

func _on_mouse_entered():
	if not Global.dragging:
		hover = true

func _on_mouse_exited():
	hover = false
