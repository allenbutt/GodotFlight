extends Node3D

signal player_enter

func _ready():
	pass


func _on_area_3d_body_entered(body):
	player_enter.emit()
