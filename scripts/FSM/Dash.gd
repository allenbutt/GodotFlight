extends State
class_name Dash

@export var character : CharacterBody3D
@export var window : Node3D
@export var player_rotation_node : Node3D
@export var Upward_Force_Timer : Timer

var player_speed = 10.0
var player_speed_max = 10.0
var acceleration = 0.75
var rotation_speed = ((360 + 60) * PI / 180) / 17
var max_normal_rotation = 90
var dashing = false

@export var dash_duration = 0.75

func Enter():
	dashing = true
	await get_tree().create_timer(dash_duration).timeout
	dashing = false
	state_transition.emit(self,"Normal")

func Exit():
	pass

func Update(delta):
	player_movement(delta)

func player_movement(delta):
	var direction = Vector3.ZERO
	var shift_bonus = 1
	
	if Input.is_action_pressed("shift"):
		shift_bonus = 1
	else:
		shift_bonus = 1

	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_down") and character.upward_force == false:
		direction.y -= 1
	if Input.is_action_pressed("move_up"):
		direction.y += 1
		
#Angle the ship's model depending on moving left and right	
	if direction.x > 0:
		player_rotation_node.rotation.z = player_rotation_node.rotation.z - rotation_speed * delta * 60
	if direction.x <= 0:
		player_rotation_node.rotation.z = player_rotation_node.rotation.z + rotation_speed * delta * 60

#Make local and global movement agree before applying velocity for the move_and_slide() function
	if direction != Vector3.ZERO:
		direction = (character.global_transform.basis * Vector3(direction.x, direction.y, 0)).normalized()
#No Acceleration on Dash
	player_speed = player_speed_max
	#If player hit ground, set direction to bounce upward
	if character.upward_force:
		direction.y = 3 * (Upward_Force_Timer.get_time_left() / Upward_Force_Timer.wait_time)
	character.velocity = direction * player_speed * shift_bonus
		
	character.move_and_slide()
