extends Node3D

var movement = 0.25
var start = 0.5

func _ready():
	$Path3D/PathFollow3D.progress = start


func _process(delta):
	$Path3D/PathFollow3D.progress = $Path3D/PathFollow3D.progress + movement
