extends CharacterBody3D

var player_health_max = 100.0
var player_shield_max = 20.0
var shield_cooldown_set = 180.0

var player_speed = 0.0
var player_speed_max = 6.0
var acceleration = 0.75
var rotation_speed = 0.167
var max_normal_rotation = 0.9
var damage_cooldown = 0.75
var taking_damage = false
var shield_cooldown = 0.0

@onready var player_rotation_node = $Player_Rotation

var upward_force = false

signal take_hit
signal set_shield

func _ready():
	Global.player_health = player_health_max

func _process(delta):
	shield_cooldown = clamp(shield_cooldown - 1, 0, 1000)
	if shield_cooldown <= 0 and Global.player_shield < player_shield_max:
		Global.player_shield = clamp(Global.player_shield + .05, 0, player_shield_max)
		set_shield.emit()


#Interaction with hitboxes like trees and missiles
func _on_area_3d_area_entered(area):
	var damage = 0.0
	#print("tree")
	if taking_damage == false:
		taking_damage = true
		$Damage_Cooldown.start(damage_cooldown)
		if area.has_method("damage_value"):
			damage = area.damage_value()
			#Global.player_health = Global.player_health - area.damage_value()
		else:
			print("tree")
			damage = Global.damage_tree
			#Global.player_health = Global.player_health - Global.damage_tree
		player_hit(damage)
#		take_hit.emit()
#		if Global.player_health <= 0:
#			queue_free()
#		hit_flash($Player_Rotation/Sprite3D)
#		shield_cooldown = shield_cooldown_set
		

#Interaction with terrain
func _on_area_3d_body_entered(body):
	var damage = Global.damage_terrain
	if upward_force == false:
#		Global.player_health = Global.player_health - Global.damage_terrain
#		take_hit.emit()
#		if Global.player_health <= 0:
#			queue_free()
		$Upward_Force_Time.start()
		upward_force = true
		player_hit(damage)
#		hit_flash($Player_Rotation/Sprite3D)
#		shield_cooldown = shield_cooldown_set

func player_hit(damage):
	var remaining_damage = damage
	var damage_applied = 0.0
	damage_applied = min(Global.player_shield, remaining_damage)
	Global.player_shield -= damage_applied
	Global.player_health -= (remaining_damage - damage_applied)
	take_hit.emit()
	if Global.player_health <= 0:
		queue_free()
	else:
		hit_flash($Player_Rotation/Sprite3D)
		shield_cooldown = shield_cooldown_set


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
