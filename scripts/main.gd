extends Node3D

var movement = 0.05
var start = 0.5

var target_xform
var offset = Vector3(0,0,0)
var lerp_speed = 1.0

@onready var player = $Window

func _ready():
	$Path3D/PathFollow3D.progress = start
	$Camera3D.target = player


func _process(delta):
	$Path3D/PathFollow3D.progress = $Path3D/PathFollow3D.progress + Global.forward_speed
#	var target_xform = self.global_transform.translated_local(offset)
#	transform.origin.z = transform.origin.z+0.1
	if Input.is_action_pressed("shift"):
		Global.forward_speed = 0.15
	else:
		Global.forward_speed = 0.1
