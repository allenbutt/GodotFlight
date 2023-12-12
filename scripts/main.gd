extends Node3D

var movement = 0.05
var start = 0.5

var target_xform
var offset = Vector3(0,0,0)
var lerp_speed = 3.0

@onready var player = $Window

func _ready():
	$Path3D/PathFollow3D.progress = start
	$Camera3D.target = player


func _process(delta):
	$Path3D/PathFollow3D.progress = $Path3D/PathFollow3D.progress + movement
#	var target_xform = self.global_transform.translated_local(offset)
#	transform.origin.z = transform.origin.z+0.1
