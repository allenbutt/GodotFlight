extends Node3D

var missile = preload("res://scenes/enemy_missile.tscn")
var laser = preload("res://scenes/laser_root.tscn")
@onready var player = $Window/Player3D

func _ready():
	laserstart()


func _process(delta):
	pass
	#missile_spawn()

func missile_spawn():
	if randi_range(0,150) == 1:
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.missile.global_position = player.global_position + Vector3(randf_range(10,15),randf_range(5,15),randf_range(-5,5))
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * 0 - enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)

func laserstart():
		var enemy_laser = laser.instantiate()
		add_child(enemy_laser)
		var laser_child = enemy_laser.laser_beam
		laser_child.global_position = $EnemyShip.global_position
		#enemy_laser.set_target_position(player.global_transform.origin)
		#print(enemy_laser.target_position)
		#print(enemy_laser.transform.normal)
		print(player.global_transform.origin)
		laser_child.global_transform = laser_child.global_transform.looking_at(laser_child.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * 0 - laser_child.global_transform.origin).normalized(), Vector3.UP)
#		enemy_laser.set_target_position(player.global_transform.origin)
#		while(true):
#			enemy_laser.global_rotation.x += 0.01
#			await get_tree().create_timer(0.01).timeout
		
