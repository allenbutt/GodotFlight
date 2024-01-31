extends Camera3D

@export var lerp_speed = 1
@export var target: Node3D
@export var offset = Vector3(0,0.5,-0.0)
#For camera shake effect
@export var period = 0.1
@export var magnitude = 0.5
@export var boundaries : Sprite3D

var camera_transform_base = self.transform

var boost_shaking = false


func _process(delta):
	if Input.is_action_pressed("shift") and boost_shaking == false and randf_range(0,1) < 0.15:
		screen_shake_boost()


#Code copied from reddit
func screen_shake():
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude), 0.0)

		self.transform.origin = camera_transform_base.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = camera_transform_base

func screen_shake_boost():
	boost_shaking = true
	var elapsed_time = 0.0
	var denominator = 20.0

	while elapsed_time < 0.1:
		var offset = Vector3(
			randf_range(-magnitude/denominator, magnitude/denominator), randf_range(-magnitude/denominator, magnitude/denominator), 0.0)

		self.transform.origin = camera_transform_base.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = camera_transform_base
	boost_shaking = false
