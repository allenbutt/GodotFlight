extends Node3D

@export var lerp_speed = 1
@export var lerp_multiplier = 45.0
@export var target: Node3D
@export var offset = Vector3(0,0,0)
var export_target = Node3D
@onready var camera = $Player3D/CameraMount/PlayerCamera
@onready var thrustersmain = $Player3D/Player_Rotation/GPU_Particles
@onready var thrustersleft = $Player3D/Player_Rotation/GPU_Particles3
@onready var thrustersright = $Player3D/Player_Rotation/GPU_Particles2
@onready var thrustersleftspin = $Player3D/Player_Rotation/GPU_Particles5
@onready var thrustersrightspin = $Player3D/Player_Rotation/GPU_Particles4
@onready var state_dashing = $Player3D/FSM/Dash

func _ready():
	pass # Replace with function body.



func _process(delta):
	if !target:
		return
	lerp_speed = Global.forward_speed * 20 * lerp_multiplier * delta
	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed / 60)
	#look_at(export_target.global_transform.origin, export_target.transform.basis.y)
	if Input.is_action_pressed("shift"):
		#camera.fov = clamp(camera.fov + 1.0 * delta * 60.0, 75.0, 85.0)
		camera.fov = lerp(camera.fov, 95.0, 2 * delta)
		thrustersleft.emitting = true
		thrustersright.emitting = true
	else:
		camera.fov = lerp(camera.fov, 70.0, 4 * delta)
		thrustersleft.emitting = false
		thrustersright.emitting = false
		#camera.fov = clamp(camera.fov - 1.0 * delta * 60.0, 75.0, 85.0)
	if state_dashing.dashing:
		thrustersleftspin.emitting = true
		thrustersrightspin.emitting = true
	else:
		thrustersleftspin.emitting = false
		thrustersrightspin.emitting = false
