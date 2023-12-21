extends Camera3D

@export var lerp_speed = 1
@export var target: Node3D
@export var offset = Vector3(0,0.5,4)

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
