extends State
class_name Normal

@export var character : CharacterBody3D
@export var window : Node3D
@export var player_rotation_node : Node3D

var player_speed = 0.0
var player_speed_max = 6.0
var acceleration = 0.75
var rotation_speed = 0.167
var max_normal_rotation = 0.9

func Enter():
	pass

func Exit():
	pass

func Update(delta):
	player_movement(delta)

func player_movement(delta):
	var direction = Vector3.ZERO
	var dash_bonus = 1
	
	if Input.is_action_pressed("shift"):
		dash_bonus = 1.5
	else:
		dash_bonus = 1

	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_down"):
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
	if direction.x == 0:
		player_speed = 0
	else:
		player_speed += acceleration
		if player_speed > player_speed_max:
			player_speed = player_speed_max
		
		character.velocity = direction * player_speed * dash_bonus * delta * 60
		
		character.move_and_slide()
