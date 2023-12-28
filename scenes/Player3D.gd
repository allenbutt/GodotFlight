extends CharacterBody3D

var player_health_max = 100.0

var player_speed = 0.0
var player_speed_max = 6.0
var acceleration = 0.75
var rotation_speed = 0.167
var max_normal_rotation = 0.9
@onready var player_rotation_node = $Player_Rotation

var upward_force = false

signal take_hit

func _ready():
	Global.player_health = player_health_max

func _process(delta):
	pass



func _on_area_3d_area_entered(area):
	Global.player_health = Global.player_health - 20
	take_hit.emit()
	print("emit")
	if Global.player_health <= 0:
		queue_free()


func _on_area_3d_body_entered(body):
	if upward_force == false:
		Global.player_health = Global.player_health - 10
		take_hit.emit()
		if Global.player_health <= 0:
			queue_free()
		$Upward_Force_Time.start()
		upward_force = true


func _on_upward_force_time_timeout():
	upward_force = false
