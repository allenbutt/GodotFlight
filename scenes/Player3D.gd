extends CharacterBody3D
var player_speed = 5.0
var rotation_speed = 0.2
var max_normal_rotation = 0.9
@onready var player_rotation_node = $Player_Rotation

func _process(delta):
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
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z - rotation_speed, max_normal_rotation * -1, max_normal_rotation)
	if direction.x < 0:
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z + rotation_speed, max_normal_rotation * -1, max_normal_rotation)
	if direction.x == 0 and player_rotation_node.rotation.z < 0:
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z + rotation_speed/1, max_normal_rotation * -1, 0)
	if direction.x == 0 and player_rotation_node.rotation.z > 0:
		player_rotation_node.rotation.z = clamp(player_rotation_node.rotation.z - rotation_speed/1, 0, max_normal_rotation)

#Make local and global movement agree before applying velocity for the move_and_slide() function
	if direction != Vector3.ZERO:
		direction = (global_transform.basis * Vector3(direction.x, direction.y, 0)).normalized()
	velocity = direction * player_speed * dash_bonus
	
		
	move_and_slide()

