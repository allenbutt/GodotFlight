extends Node3D

var movement = 0.05
var start = 0.5

var target_xform
var offset = Vector3(0,0,0)
var lerp_speed = 1.0

var move_enemy_1 = false
var move_enemy_2 = false
var test_explode = false
var test_explode2 = false
var test_explode3 = false

@onready var player = $Window
@onready var ui = $ui_canvas
@onready var player3d = $Window/Player3D

func _ready():
	$Path3D/PathFollow3D.progress = start
	$Camera3D.target = player
	$Window.export_target = $Camera3D
	player3d.take_hit.connect(player_take_hit)
	


func _process(delta):
	if Input.is_action_pressed("shift"):
		Global.forward_speed = Global.forward_speed_base * 1.5
	else:
		Global.forward_speed = Global.forward_speed_base
	$Path3D/PathFollow3D.progress = $Path3D/PathFollow3D.progress + Global.forward_speed * delta * 60
	enemy_movement(delta)

func enemy_movement(delta):
	if move_enemy_1 == false and $Path3D/PathFollow3D.progress > 80:
		$EnemyShip1Path/PathFollow3D.progress += (0.12 * delta * 60)
		if $EnemyShip1Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_1 = true
	if move_enemy_2 == false and $Path3D/PathFollow3D.progress > 260:
		$EnemyShip2Path/PathFollow3D.progress += (0.12 * delta * 60)
		if $EnemyShip2Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_2 = true
	if test_explode == false and $Path3D/PathFollow3D.progress > 25.9:
		test_explode = true
		$Explosion/Node3D/GPU_Shockwave.emitting = true
		$Explosion/Node3D/ParticlesExplosionCloud.emitting = true
		$Explosion/Node3D/ParticlesExplosionCloud2.emitting = true
		$Explosion/Node3D/ParticlesExplosionCloud3.emitting = true
		$Explosion/Node3D/GPU_Particles.emitting = true
	if test_explode2 == false and $Path3D/PathFollow3D.progress > 38.25:
		test_explode2 = true
		$Explosion2/Node3D/GPU_Shockwave.emitting = true
		$Explosion2/Node3D/ParticlesExplosionCloud.emitting = true
		$Explosion2/Node3D/ParticlesExplosionCloud2.emitting = true
		$Explosion2/Node3D/ParticlesExplosionCloud3.emitting = true
		$Explosion2/Node3D/GPU_Particles.emitting = true
	if test_explode3 == false and $Path3D/PathFollow3D.progress > 40:
		test_explode3 = true
		$Explosion3/Node3D/GPU_Shockwave.emitting = true
		$Explosion3/Node3D/ParticlesExplosionCloud.emitting = true
		$Explosion3/Node3D/ParticlesExplosionCloud2.emitting = true
		$Explosion3/Node3D/ParticlesExplosionCloud3.emitting = true
		$Explosion3/Node3D/GPU_Particles.emitting = true
		
func player_take_hit():
	ui.set_healthbar_value(Global.player_health)
	$Camera3D.screen_shake()
