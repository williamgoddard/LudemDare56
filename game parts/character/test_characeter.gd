class_name GameCharacter extends Node2D

const SPEED = 300.0
const ROOM_X_BOARDER = 64
const ROOM_Y_BOARDER = 64 

@export var target_room : Room = null
@export var bedroom : Room = null
@export var desire := Global.Desire.NONE

@export var move_up : bool
@export var move_down : bool
@export var move_left : bool
@export var move_right : bool
@export var stop_all_movement : bool

@onready var random_timer = $Random_Timer
@onready var inactivity_timer = $Inactivity_Timer
const WANDER_TIME := 5.0 #Time until wadering
const INACTIVITY_TIME := 5.0 #Time until wadering
var target_position
var randomly_moving
var command_queue ##Command queue variable
signal movement_finished(direction)

func _ready():
	random_timer.wait_time = WANDER_TIME
	
	pass

func _physics_process(delta):
	check_stop_movement()
	check_movement_finished()
	if Input.is_action_pressed("ui_left") or move_left:
		position.x -= SPEED * delta
		randomly_moving = false
	if Input.is_action_pressed("ui_right") or move_right:
		position.x += SPEED * delta
		randomly_moving = false
	if Input.is_action_pressed("ui_up") or move_up:
		position.y -= SPEED * delta
		randomly_moving = false
	if Input.is_action_pressed("ui_down") or move_down:
		position.y += SPEED * delta
		randomly_moving = false
	#if randomly_moving:
		#position = position.move_toward(target_position, SPEED * delta)
	#if position == target_position:
		#inactivity_timer.start()

func check_stop_movement():
	if stop_all_movement:
		move_up = false
		move_down = false
		move_left = false
		move_right = false
		
func check_movement_finished():
	if position.y < -ROOM_Y_BOARDER:
		movement_finished.emit(Global.Direction.UP)
		print(Global.Direction.UP)
	if position.y > ROOM_Y_BOARDER:
		movement_finished.emit(Global.Direction.DOWN)
		print(Global.Direction.DOWN)
	if position.x < -ROOM_X_BOARDER:
		movement_finished.emit(Global.Direction.LEFT)
		print(Global.Direction.LEFT)
	if position.x > ROOM_X_BOARDER:
		movement_finished.emit(Global.Direction.RIGHT)
		print(Global.Direction.RIGHT)

func random_movement():
	var new_x = randf_range(-32, +32)
	pass

func _on_random_timer_timeout():
	pass # Replace with function body.


func _on_incativity_timer_timeout():
	pass # Replace with function body.

func execute_path(path):
	command_queue = path
	process_next_command()


func process_next_command():
	if command_queue.size() > 0:
		var movement_command = command_queue.pop_front() 
		match movement_command:
			Global.Direction.UP:
				move_up = true
			Global.Direction.DOWN:
				move_down = true
			Global.Direction.LEFT:
				move_left = true
			Global.Direction.RIGHT:
				move_right = true

func _on_movement_finished(direction):
	pass # Replace with function body.
