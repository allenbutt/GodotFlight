extends CharacterBody2D

var player_speed = 400.0
var rotation_speed = 0.1
var max_normal_rotation = 0.45

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	var direction = Vector2.ZERO
	var dash_bonus = 1
	
	if Input.is_action_pressed("shift"):
		dash_bonus = 1.5
	else:
		dash_bonus = 1

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	if direction.x < 0:
		self.rotation = clamp(self.rotation - rotation_speed, max_normal_rotation * -1, max_normal_rotation)
	if direction.x > 0:
		self.rotation = clamp(self.rotation + rotation_speed, max_normal_rotation * -1, max_normal_rotation)
	if direction.x == 0 and self.rotation < 0:
		self.rotation = clamp(self.rotation + rotation_speed/1, max_normal_rotation * -1, 0)
	if direction.x == 0 and self.rotation > 0:
		self.rotation = clamp(self.rotation - rotation_speed/1, 0, max_normal_rotation)
	
	velocity.x = direction.x * player_speed * dash_bonus
	velocity.y = direction.y * player_speed * dash_bonus
		
	move_and_slide()
