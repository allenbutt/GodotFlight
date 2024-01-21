extends Node3D

@export var lerp_speed = 1
@export var target: Node3D
@export var offset = Vector3(0,0,0)
var export_target = Node3D

func _ready():
	pass # Replace with function body.



func _process(delta):
	if !target:
		return
	lerp_speed = Global.forward_speed * 20
	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed / 60)
	#look_at(export_target.global_transform.origin, export_target.transform.basis.y)
