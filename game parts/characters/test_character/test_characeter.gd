extends Node2D


const SPEED = 300.0
const ROOM_X_BOARDER = 64
const ROOM_Y_BOARDER = 64
@export var move_up : bool
@export var move_down : bool
@export var move_left : bool
@export var move_right : bool
@export var stop_all_movement : bool

signal movement_finished

func _physics_process(delta):
	check_stop_movement()
	check_movement_finished()
	if Input.is_action_pressed("ui_left") or move_left:
		position.x -= SPEED * delta
	if Input.is_action_pressed("ui_right") or move_right:
		position.x += SPEED * delta
	if Input.is_action_pressed("ui_up") or move_up:
		position.y -= SPEED * delta
	if Input.is_action_pressed("ui_down") or move_down:
		position.y += SPEED * delta

	

func check_stop_movement():
	if stop_all_movement:
		move_up = false
		move_down = false
		move_left = false
		move_right = false
		
func check_movement_finished():
	if position.x > ROOM_X_BOARDER or position.x < -ROOM_X_BOARDER:
		movement_finished.emit()
		print("yay")
	if position.y > ROOM_Y_BOARDER or position.y < -ROOM_Y_BOARDER:
		movement_finished.emit()
		print("yay")
