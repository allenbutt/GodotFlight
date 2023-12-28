extends State
class_name Normal

@export var character : CharacterBody3D
@export var window : Node3D
@export var player_rotation_node : Node3D
@export var dash_cooldown_timer : Timer
@export var Upward_Force_Timer : Timer

var player_speed = 0.0
var player_speed_max = 5.0
var acceleration = 0.75
var rotation_speed = 0.167
var max_normal_rotation = 0.9

func Enter():
	pass

func Exit():
	pass

func Update(delta):
	if Input.is_action_just_pressed("spacebar") and dash_cooldown_timer.get_time_left() == 0:
		dash_cooldown_timer.start()
		state_transition.emit(self,"Dash")
	else:
		player_movement(delta)

func player_movement(delta):
	var direction = Vector3.ZERO
	var shift_bonus = 1
	
	if Input.is_action_pressed("shift"):
		shift_bonus = 0.85
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
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z - rotation_speed * delta * 60, max_normal_rotation * -1, max_normal_rotation)
	if direction.x < 0:
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z + rotation_speed * delta * 60, max_normal_rotation * -1, max_normal_rotation)
	if direction.x == 0 and player_rotation_node.rotation.z < 0:
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z + rotation_speed * delta * 60/1, max_normal_rotation * -1, 0)
	if direction.x == 0 and player_rotation_node.rotation.z > 0:
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z - rotation_speed * delta * 60/1, 0, max_normal_rotation)

#Make local and global movement agree before applying velocity for the move_and_slide() function
	if direction != Vector3.ZERO:
		direction = (character.global_transform.basis * Vector3(direction.x, direction.y, 0)).normalized()
#If no movement, set speed to 0 and skip move_and_slide
	if direction.x == 0 and character.upward_force == false:
		player_speed = 0
	else:
		player_speed += acceleration
		if player_speed > player_speed_max:
			player_speed = player_speed_max
	#If player hit ground, set direction to bounce upward
	if character.upward_force:
		direction.y = 3 * (Upward_Force_Timer.get_time_left() / Upward_Force_Timer.wait_time)
		
	character.velocity = direction * player_speed * shift_bonus * delta * 60
	
	character.move_and_slide()
