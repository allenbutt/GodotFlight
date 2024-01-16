extends CharacterBody3D

var player_health_max = 100.0

var player_speed = 0.0
var player_speed_max = 6.0
var acceleration = 0.75
var rotation_speed = 0.167
var max_normal_rotation = 0.9
var damage_cooldown = 0.75
var taking_damage = false
@onready var player_rotation_node = $Player_Rotation

var upward_force = false

signal take_hit

func _ready():
	Global.player_health = player_health_max

func _process(delta):
	pass


#Interaction with hitboxes like trees and missiles
func _on_area_3d_area_entered(area):
	if taking_damage == false:
		taking_damage = true
		$Damage_Cooldown.start(damage_cooldown)
		if area.has_method("damage_value"):
			Global.player_health = Global.player_health - area.damage_value()
		else:
			Global.player_health = Global.player_health - Global.damage_tree
		take_hit.emit()
		if Global.player_health <= 0:
			queue_free()
		hit_flash($Player_Rotation/Sprite3D)

#Interaction with terrain
func _on_area_3d_body_entered(body):
	if upward_force == false:
		Global.player_health = Global.player_health - Global.damage_terrain
		take_hit.emit()
		if Global.player_health <= 0:
			queue_free()
		$Upward_Force_Time.start()
		upward_force = true
		hit_flash($Player_Rotation/Sprite3D)


func _on_upward_force_time_timeout():
	upward_force = false

func hit_flash(sprite):
	var flash_duration = 0.025
	sprite.material_override.set_shader_parameter("active", true)
	for x in range(0,3):
		sprite.material_override.set_shader_parameter("flash_color", Color(0.827, 0, 0.094))
		await get_tree().create_timer(flash_duration*2).timeout
		sprite.material_override.set_shader_parameter("flash_color", Color(1, 1, 1))
		await get_tree().create_timer(flash_duration).timeout
	sprite.material_override.set_shader_parameter("active", false)


func _on_damage_cooldown_timeout():
	taking_damage = false
