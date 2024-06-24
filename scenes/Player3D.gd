extends CharacterBody3D

var player_health_max = 200.0
var player_shield_max = 50.0
var shield_cooldown_set = 300.0

var player_speed = 0.0
var player_speed_max = 6.0
var acceleration = 0.75
var rotation_speed = 0.167
var max_normal_rotation = 0.9
var damage_cooldown = 0.75
var taking_damage = false
var hit_slowdown = false
var shield_cooldown = 0.0
var sound_going = false

@onready var player_rotation_node = $Player_Rotation
@onready var blackout = $Blackout
@onready var blackout_animation_player = $Blackout/AnimationPlayer
@onready var forward_point = $Forward_Direction_Point

var tree_whoosh = preload("res://scenes/tree_whoosh_standalone.tscn")
var tree_whoosh2 = preload("res://scenes/tree_whoosh_standalone_2.tscn")

var upward_force = false

signal take_hit
signal set_shield
signal player_death
signal explosion_screen_shake

func _ready():
	Global.player_health = player_health_max
	Global.player_shield = player_shield_max
	blackout_animation_player.play("fade_in")


func _process(delta):
	shield_cooldown = clamp(shield_cooldown - 1 * delta * 60, 0, 1000)
	if shield_cooldown <= 0 and Global.player_shield < player_shield_max:
		Global.player_shield = clamp(Global.player_shield + .05 * delta * 60, 0, player_shield_max)
		set_shield.emit()
	if Global.victory:
		$ForwardSound.stop()
		$ForwardSound2.stop()


#Interaction with hitboxes like trees and missiles
func _on_area_3d_area_entered(area):
	var damage = 0.0
	#print("tree")
	if taking_damage == false and Global.alive:
		taking_damage = true
		$Damage_Cooldown.start(damage_cooldown)
		if area.has_method("damage_value"):
			damage = area.damage_value()
			#Global.player_health = Global.player_health - area.damage_value()
		else:
			damage = Global.damage_tree
			#Global.player_health = Global.player_health - Global.damage_tree
		damage = damage * randf_range(0.8,1.2)
		$TakeHitSound.pitch_scale = randf_range(1.0,2.0)
		$TakeHitSound.play()
		player_hit(damage)

#Interaction with terrain
func _on_area_3d_body_entered(body):
	var damage = Global.damage_terrain
	if upward_force == false and Global.alive:
		$Upward_Force_Time.start()
		$TakeHitGroundSound.pitch_scale = randf_range(1.0,2.0)
		$TakeHitGroundSound.play()
		upward_force = true
		damage = damage * randf_range(0.8,1.2)
		player_hit(damage)

func player_hit(damage):
	var remaining_damage = damage
	var damage_applied = 0.0
	damage_applied = min(Global.player_shield, remaining_damage)
	Global.player_shield -= damage_applied
	Global.player_health -= (remaining_damage - damage_applied)
	take_hit.emit()
	if Global.player_health <= 0:
		$Player_Rotation/Sprite3D.visible = false
		Global.alive = false
		player_death.emit()
		$ForwardSound.stop()
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

func fade_blackout():
	blackout_animation_player.play("fade_out")

func destroy_blackout():
	blackout.visible = false


func _on_area_3d_explosion_screenshake_area_entered(area):
	explosion_screen_shake.emit()


func _on_area_camera_tree(area):
	var whoosh_sound
	if randf() > 0.0:
		whoosh_sound = tree_whoosh.instantiate()
		whoosh_sound.pitch_scale = randf_range(0.5,1.0)
	else:
		whoosh_sound = tree_whoosh2.instantiate()
		whoosh_sound.pitch_scale = randf_range(0.5,1.0)
	whoosh_sound.position = area.position
	add_child(whoosh_sound)
	whoosh_sound.play()


func _on_laser_audio_detection_area_area_entered(area):
	area.player_hit(forward_point)

func start_sound():
	$ForwardSound.play()
	$ForwardSound.volume_db = -10.0
	$ForwardSound2.play()
	$ForwardSound2.volume_db = -10.0
	while $ForwardSound.volume_db < 0.00:
		$ForwardSound.volume_db = $ForwardSound.volume_db + 0.25
		await get_tree().create_timer(0.05).timeout
