class_name GameCharacter extends Node2D

const SPEED = 20.0
const ROOM_X_BOARDER = 64
const ROOM_Y_BOARDER = 64 


@export var target_room : Room = null
@export var bedroom : Room = null
@export var desire := Global.Desire.NONE

var move_up : bool
var move_down : bool
var move_left : bool
var move_right : bool
@export var stop_all_movement : bool
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var random_timer = $Random_Timer
@onready var inactivity_timer = $Inactivity_Timer
const WANDER_TIME := 5.0 #Time until wadering
const INACTIVITY_TIME := 6.0 #Time until wadering
var internal_target_x := 0.0
var internally_moving := false
var command_queue ##Command queue variable
enum STATES {IDLE, WANDER, MOVING_GOAL}
var state
var next_vertical_command
var internally_moving_centre = false
var vik_var := false

signal movement_finished(node_ID,direction)
signal movement_finished_internal

func _ready():
	random_timer.wait_time = WANDER_TIME
	inactivity_timer.wait_time = INACTIVITY_TIME
	state = STATES.IDLE
	animated_sprite_2d.play("idle")
	animated_sprite_2d.material.set_shader_parameter('New Color',get_random_color())
	pass

func get_random_color() -> Color:
	return Color(
		randf(),
		randf(),
		randf()
	)

func _physics_process(delta):
	check_stop_movement()
	check_movement_finished()
	if Input.is_action_pressed("ui_left") or move_left:
		position.x -= SPEED * delta
		#randomly_moving = false
	if Input.is_action_pressed("ui_right") or move_right:
		position.x += SPEED * delta
		#randomly_moving = false
	if Input.is_action_pressed("ui_up") or move_up:
		position.y -= SPEED * delta
		#randomly_moving = false
	if Input.is_action_pressed("ui_down") or move_down:
		position.y += SPEED * delta
	if state == STATES.IDLE:
		inactivity_timer.start()
	if state == STATES.WANDER:
		random_timer.start()
	if vik_var:
		process_reparent()
		vik_var = false
		
		#randomly_moving = false
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
		movement_finished.emit(self,Global.Direction.UP)
		print(Global.Direction.UP)
	if position.y > ROOM_Y_BOARDER:
		movement_finished.emit(self,Global.Direction.DOWN)
		print(Global.Direction.DOWN)
	if position.x < -ROOM_X_BOARDER:
		movement_finished.emit(self,Global.Direction.LEFT)
		print(Global.Direction.LEFT)
	if position.x > ROOM_X_BOARDER:
		movement_finished.emit(self,Global.Direction.RIGHT)
		print(Global.Direction.RIGHT)
	if abs(position.x - internal_target_x) > 1 and internally_moving:
		movement_finished_internal.emit()
	pass
	if abs(position.x - internal_target_x) > 1 and internally_moving:
		movement_finished_internal.emit()
	pass
	#print("Position ", abs(position.y - 55.0))
	if internally_moving_centre and abs(position.x) < 1 and abs(position.y - 55) < 1:
		print("you are here")
		movement_finished_internal.emit()

func random_movement():
	var new_offset = randf_range(-32, +32)
	var new_x = position.x + new_offset
	new_x = clamp(new_x, -ROOM_X_BOARDER, ROOM_X_BOARDER)
	move_toward_x(new_x)
	pass

func _on_random_timer_timeout():
	random_movement()
	pass # Replace with function body.


func _on_incativity_timer_timeout():
	random_movement()
	state = STATES.WANDER
	pass # Replace with function body.

func move_toward_x(target_x):
	if position.x < target_x:
		move_right = true
		move_left = false
	elif position.x > target_x:
		move_left = true
		move_right = false
	#update target
	internally_moving = true
	internal_target_x = target_x
	
func go_centre():
	if abs(position.x) > 1:
		if position.x < 0.0:
			move_right = true
			move_left = false
		elif position.x > 0.0:
			move_left = true
			move_right = false
		internally_moving_centre = true
	if abs(position.y - 55) > 1:
		if position.y < 55.0:
			move_up = false
			move_down = true
		elif position.y > 55.0:
			move_up = true
			move_down = false
		#update target
		internally_moving_centre = true

func execute_path(path):
	internally_moving = false
	internal_target_x = 0.0
	command_queue = path
	process_next_command()


func process_next_command():
	if command_queue.size() > 0:
		state = STATES.MOVING_GOAL
		var movement_command = command_queue.pop_front() 
		match movement_command:
			Global.Direction.UP,Global.Direction.DOWN:
				if abs(position.x - 0.0) > 1:
					move_toward_x(0.0)
					next_vertical_command = movement_command
				else:
					match movement_command:
						Global.Direction.UP:
							move_up = true
						Global.Direction.DOWN:
							move_down = true
			Global.Direction.LEFT:
				move_left = true
			Global.Direction.RIGHT:
				move_right = true
	else:
		move_toward_x(0.0)
		state = STATES.IDLE

func _on_movement_finished(node_id,direction):
	move_up = false
	move_down = false
	move_left = false
	move_right = false
	
	await get_tree().create_timer(0.1).timeout
	#process_next_command()
	pass

func _on_movement_finished_internal():
	move_up = false
	move_down = false
	move_left = false
	move_right = false
	internally_moving = false
	internally_moving_centre = false

	# After moving to x = 0.0, execute the stored vertical movement
	if next_vertical_command != null:
		match next_vertical_command:
			Global.Direction.UP:
				move_up = true
			Global.Direction.DOWN:
				move_down = true
		next_vertical_command = null  # Clear after execution

func process_reparent():
	go_centre()
	await movement_finished_internal
	process_next_command()
	
