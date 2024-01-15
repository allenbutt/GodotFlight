extends Node3D

var movement = 0.05
var start = 0.5
#0.5 start
#440.0 downhill
#888.0 sharp turn

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

var explosion = preload("res://scenes/explosion.tscn")
var missile = preload("res://scenes/enemy_missile.tscn")

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
	demo_explode()

func enemy_movement(delta):
	if move_enemy_1 == false and $Path3D/PathFollow3D.progress > 80:
		$EnemyShip1Path/PathFollow3D.progress += (0.12 * delta * 60)
		if $EnemyShip1Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_1 = true
	if move_enemy_2 == false and $Path3D/PathFollow3D.progress > 260:
		$EnemyShip2Path/PathFollow3D.progress += (0.12 * delta * 60)
		if $EnemyShip2Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_2 = true

		
func player_take_hit():
	ui.set_healthbar_value(Global.player_health)
	$Camera3D.screen_shake()

func demo_explode():
	if randi_range(0,60) == 1:
#		var explode = explosion.instantiate()
#		explode.global_position = player.global_position + Vector3(randf_range(-20,20),0,8 + randf_range(0,12))
#		add_child(explode)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.global_position = player3d.global_position + Vector3(randf_range(-10,10),6,2 + randf_range(0,12))
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player3d.global_transform.origin - enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
