extends Node3D

var movement = 0.05
var start = 0.5

var target_xform
var offset = Vector3(0,0,0)
var lerp_speed = 1.0

var move_enemy_1 = false

@onready var player = $Window

func _ready():
	$Path3D/PathFollow3D.progress = start
	$Camera3D.target = player
	$Window.export_target = $Camera3D


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
		
