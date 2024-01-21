extends Node3D

var rotation_speed = 0.0075

func _ready():
	pass


func _process(delta):
	rotation.y += rotation_speed * delta * 60
