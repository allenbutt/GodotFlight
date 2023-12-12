extends Node3D

@export var lerp_speed = 3
@export var target: Node3D
@export var offset = Vector3(0,0,0)

func _ready():
	pass # Replace with function body.



func _process(delta):
	if !target:
		return

	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)

