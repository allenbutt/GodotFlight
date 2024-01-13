extends Camera3D

@export var lerp_speed = 1
@export var target: Node3D
@export var offset = Vector3(0,0.5,-0.0)
#For camera shake effect
@export var period = 0.1
@export var magnitude = 0.1

func _process(delta):
	if !target:
		return
	lerp_speed = Global.forward_speed * 20
	if Input.is_action_pressed("shift"):
		lerp_speed = lerp_speed * 0.75
	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)

	if global_transform.origin.is_equal_approx(target.transform.basis.y) == false:
		look_at(target.global_transform.origin, target.transform.basis.y)
	if Input.is_action_pressed("shift"):
		screen_shake_boost()


#Code copied from reddit
func screen_shake():
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude), 0.0)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	self.transform = initial_transform

func screen_shake_boost():
	var boost_magnitude = 0.05
	var initial_transform = self.transform 
	var elapsed_time = 0.0
	var offset = Vector3(randf_range(-boost_magnitude, boost_magnitude), randf_range(-boost_magnitude, boost_magnitude), 0.0)
	if randi_range(0,2) == 1:
		offset = self.transform.translated_local(offset)
		self.transform = self.transform.interpolate_with(offset, 0.2)
