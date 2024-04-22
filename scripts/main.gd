extends Node3D

var movement = 0.05
var start = 0.5
#0.5 start
#222.0 first_lake
#440.0 downhill
#888.0 sharp turn

var go_forward = false

var target_xform
var offset = Vector3(0,0,0)
var lerp_speed = 1.0
var go_faster = false
var go_faster_amount = 0.06
var go_faster2 = false
var go_faster_amount2 = 0.06

var move_enemy_1 = false
var move_enemy_2 = false
var move_enemy_3 = false
var move_enemy_4 = false
var move_enemy_5 = false
var move_enemy_6 = false
var test_explode = false
var test_explode2 = false
var test_explode3 = false

var enemy1_attack_start = false
var enemy2_attack_start = false
var enemy2_attack_start2 = false
var enemy3_attack_start = false
var enemy3_attack_start2 = false
var enemy4_attack_start = false
var enemy4_attack_start2 = false
var enemy5_attack_start = false
var enemy6_attack_start = false
var final_attack_start = false

@onready var player = $Window
@onready var ui = $ui_canvas
@onready var player3d = $Window/Player3D
@onready var playercam = $Window/Player3D/CameraMount/PlayerCamera
@onready var menu = $Menu
@onready var multimeshes = $MultiMeshes
@onready var environment = $WorldEnvironment

var explosion = preload("res://scenes/explosion.tscn")
var missile = preload("res://scenes/enemy_missile.tscn")
var laser = preload("res://scenes/laser_root.tscn")

func _ready():
	menu.BeginGame.connect(_start_game)
	menu.ToggleParticles.connect(_toggle_particles)
	menu.ToggleGraphics.connect(_toggle_graphics)
	#$Camera3D.current = true
	$Path3D/PathFollow3D.progress = start
	$Camera3D.target = player
	$Window.export_target = $Camera3D
	player3d.take_hit.connect(player_take_hit)
	player3d.set_shield.connect(player_set_shield)
	$Path3D/PathFollow3D.progress = start
	$EnemyShip4Path/PathFollow3D/EnemyShip4.rotation_speed = 0.015
	
	$Window/Boundaries.visible = false
	$ui_canvas.visible = false

func _start_game():
	print("startgame")
	$Menu.visible = false
	$ui_canvas.visible = true
	await get_tree().create_timer(1.0).timeout
	#$Window/Boundaries.visible = true
	go_forward = true
	Global.moving = true
	$ui_canvas.visible = true
	#player3d.position = Vector3(0.0,0.0,0.0)
	
	await get_tree().create_timer(0.5).timeout
	$Window/Boundaries.visible = true
	#$ui_canvas.visible = true
	
	player3d.fade_blackout()

func _process(delta):
	if Input.is_action_pressed("shift"):
		Global.forward_speed = Global.forward_speed_base * 1.33
	else:
		Global.forward_speed = Global.forward_speed_base
	if player3d.taking_damage:
		Global.forward_speed = Global.forward_speed * 0.75
	if go_forward:
		$Path3D/PathFollow3D.progress = $Path3D/PathFollow3D.progress + Global.forward_speed * delta * 60
	enemy_movement(delta)
	if go_faster == false and $Path3D/PathFollow3D.progress > 450.0:
		go_faster = true
		enact_go_faster()
	if go_faster2 == false and $Path3D/PathFollow3D.progress > 1640.0:
		go_faster2 = true
		enact_go_faster()
	#demo_explode()

func enemy_movement(delta):
	if move_enemy_1 == false and $Path3D/PathFollow3D.progress > 125:
		$EnemyShip1Path/PathFollow3D.progress += (0.12 * delta * 60)
		if $EnemyShip1Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_1 = true
	if $Path3D/PathFollow3D.progress >= 210.0 and enemy1_attack_start == false:
		enemy1_attack()
	if move_enemy_2 == false and $Path3D/PathFollow3D.progress > 235:
		$EnemyShip2Path/PathFollow3D.progress += (0.12 * delta * 60)
		if $Path3D/PathFollow3D.progress > 295.0 and enemy2_attack_start == false:
			enemy2_attack()
		if $EnemyShip2Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_2 = true
	if $Path3D/PathFollow3D.progress >= 355.0 and enemy2_attack_start2 == false:
		enemy2_attack2()
	if move_enemy_3 == false and (($Path3D/PathFollow3D.progress > 815 and $EnemyShip3Path/PathFollow3D.progress < 168.0) \
	or $Path3D/PathFollow3D.progress > 1100.0):
		$EnemyShip3Path/PathFollow3D.progress += (0.18 * delta * 60)
		if $EnemyShip3Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_3 = true
	if $Path3D/PathFollow3D.progress >= 836.0 and enemy3_attack_start == false:
		enemy3_attack()
	if move_enemy_4 == false and (($Path3D/PathFollow3D.progress > 1150.0 and $EnemyShip4Path/PathFollow3D.progress < 48.0) \
	or $Path3D/PathFollow3D.progress > 1500.0):
		if $EnemyShip4Path/PathFollow3D.progress_ratio >= 0.90:
			$EnemyShip4Path/PathFollow3D.progress += (0.10 * delta * 60)
		elif $Path3D/PathFollow3D.progress > 1500.0 and $EnemyShip4Path/PathFollow3D.progress < 285.0:
			$EnemyShip4Path/PathFollow3D.progress += (0.30 * delta * 60)
		else:
			$EnemyShip4Path/PathFollow3D.progress += (0.10 * delta * 60)
		if $EnemyShip4Path/PathFollow3D.progress_ratio >= 0.97:
			move_enemy_4 = true
	if $Path3D/PathFollow3D.progress >= 1250.0 and enemy4_attack_start == false:
		enemy4_attack()
	if move_enemy_5 == false and $Path3D/PathFollow3D.progress > 1170:
		$EnemyShip5Path/PathFollow3D.progress += (0.2 * delta * 60)
		if $EnemyShip5Path/PathFollow3D.progress_ratio >= 0.95:
			move_enemy_5 = true
	if $Path3D/PathFollow3D.progress >= 1700.0 and enemy4_attack_start2 == false:
		enemy4_attack2()
	if $Path3D/PathFollow3D.progress >= 1993.0 and enemy3_attack_start2 == false:
		enemy3_attack2()
	if $Path3D/PathFollow3D.progress >= 2010.0 and enemy5_attack_start == false:
		enemy5_attack()
	if $Path3D/PathFollow3D.progress >= 2280.0 and final_attack_start == false:
		final_attack_start = true
		final_attack($EnemyShip)
		final_attack($EnemyShip2)
		final_attack($EnemyShip3)
		final_attack($EnemyShip4)


		
func player_take_hit():
	ui.set_healthbar_value(Global.player_health)
	ui.set_shieldbar_value(Global.player_shield)
	playercam.screen_shake()
func player_set_shield():
	ui.set_shieldbar_value(Global.player_shield)

func demo_explode():
	if randi_range(0,100) == 1:
		var forward_offset = randf_range(14.0, 24.0) * Global.forward_speed * 8
#		var explode = explosion.instantiate()
#		explode.global_position = player.global_position + Vector3(randf_range(-20,20),0,8 + randf_range(0,12))
#		add_child(explode)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.global_position = player3d.global_position + Vector3(randf_range(-10,10),randf_range(6,20),20 + randf_range(0,20))
#		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
#		(player3d.global_transform.origin - enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset - enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)

func enact_go_faster():
	var starting_base_speed = Global.forward_speed_base
	while(Global.forward_speed_base < starting_base_speed + go_faster_amount):
		Global.forward_speed_base = clamp(0, Global.forward_speed_base+.001, starting_base_speed + go_faster_amount)
		await get_tree().create_timer(0.04).timeout

func enemy1_attack():
	enemy1_attack_start = true
	var enemy = $EnemyShip1Path/PathFollow3D/EnemyShip
	for count in range(0,24):
		for count2 in range(0,2):
			var forward_offset = count * 1 + 20
			var other_offset = Vector3(randf_range(-12,12),randf_range(-5.0,5.0),0)
			var enemy_laser = laser.instantiate()
			add_child(enemy_laser)
			var laser_child = enemy_laser.laser_beam
			laser_child.global_position = enemy.global_position
			#enemy_laser.global_position = enemy.global_position + enemy.global_transform.looking_at(enemy.global_transform.origin - player.global_transform.origin, ) * 0.8
			laser_child.global_transform = laser_child.global_transform.looking_at(laser_child.global_transform.origin - \
			(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
			player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
			laser_child.global_transform.origin).normalized(), Vector3.FORWARD)
		await get_tree().create_timer(randf_range(0.075,0.15)).timeout

func enemy2_attack():
	enemy2_attack_start = true
	var enemy = $EnemyShip2Path/PathFollow3D/EnemyShip2
	for count in range(0,22):
		var forward_offset = randf_range(10.0, 25.0) * Global.forward_speed * 8
		var other_offset = Vector3(randf_range(-5.0,5.0),randf_range(-5.0,5.0),0)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.remove_targeting()
		enemy_missile.speed_multiplier = 3.0
		enemy_missile.global_position = enemy.global_position
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
		player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
		enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		await get_tree().create_timer(0.20).timeout

func enemy2_attack2():
	enemy2_attack_start2 = true
	var enemy = $EnemyShip2Path/PathFollow3D/EnemyShip2
	for count in range(0,22):
		var forward_offset = randf_range(20.0, 30.0) * Global.forward_speed * 8
		var other_offset = Vector3(randf_range(-12.0,12.0),randf_range(-12.0,12.0),0)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.speed_multiplier = 2.5
		enemy_missile.global_position = enemy.global_position
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
		player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
		enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		await get_tree().create_timer(0.33).timeout

func enemy3_attack():
	enemy3_attack_start = true
	var enemy = $EnemyShip3Path/PathFollow3D/EnemyShip
	for count in range(0,14):
		var forward_offset = randf_range(5.0, 10.0) * Global.forward_speed * 8
		var other_offset = Vector3(randf_range(-12.0,12.0),randf_range(-12.0,12.0),0)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.remove_targeting()
		enemy_missile.speed_multiplier = 2.0
		enemy_missile.global_position = enemy.global_position
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
		player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
		enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(2.0).timeout
	for count in range(0,35):
		var distance_between = enemy.global_transform.origin.distance_to(player.global_transform.origin)
		var forward_offset = randf_range(15.0, 25.0) * Global.forward_speed * 8 + distance_between * 0.2
		var other_offset = Vector3(randf_range(-6.0,6.0),randf_range(-6.0,6.0),0)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.speed_multiplier = 2.0
		enemy_missile.global_position = enemy.global_position
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
		player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
		enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		await get_tree().create_timer(randf_range(0.3,0.5)).timeout
func enemy4_attack():
	enemy4_attack_start = true
	var enemy = $EnemyShip4Path/PathFollow3D/EnemyShip4
	for count in range(0,59):
		for count2 in range(0,2):
			var forward_offset = pow(count,1.1) * 2.25 + 20 + randf_range(0,1)
			var other_offset = Vector3(0,randf_range(-1,8.0) - count/5,0)
			var enemy_laser = laser.instantiate()
			add_child(enemy_laser)
			var laser_child = enemy_laser.laser_beam
			laser_child.global_position = enemy.global_position
			#enemy_laser.global_position = enemy.global_position + enemy.global_transform.looking_at(enemy.global_transform.origin - player.global_transform.origin, ) * 0.8
			laser_child.global_transform = laser_child.global_transform.looking_at(laser_child.global_transform.origin - \
			(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
			player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
			laser_child.global_transform.origin).normalized(), Vector3.FORWARD)
		await get_tree().create_timer(randf_range(0.125,0.20)).timeout
func enemy4_attack2():
	var enemy = $EnemyShip4Path/PathFollow3D/EnemyShip4
	enemy4_attack_start2 = true
	for count in range(0,28):
		var distance_between = enemy.global_transform.origin.distance_to(player.global_transform.origin)
		var forward_offset = 74 * Global.forward_speed + distance_between * 0.2
		var other_offset = Vector3(randf_range(-6.0,6.0),randf_range(-6.0,6.0),0)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.speed_multiplier = 2.0
		enemy_missile.global_position = enemy.global_position
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
		player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
		enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		await get_tree().create_timer(randf_range(0.45,0.55)).timeout
func enemy3_attack2():
	enemy3_attack_start2 = true
	var enemy = $EnemyShip3Path/PathFollow3D/EnemyShip
	for count in range(0,33):
		for count2 in range(0,2):
			var forward_offset = pow(count,1.1) * 2.25 + 20 + randf_range(0,1)
			var other_offset = Vector3(0,randf_range(-4,6.0) - count/5 * 0,0)
			var enemy_laser = laser.instantiate()
			add_child(enemy_laser)
			var laser_child = enemy_laser.laser_beam
			laser_child.global_position = enemy.global_position
			#enemy_laser.global_position = enemy.global_position + enemy.global_transform.looking_at(enemy.global_transform.origin - player.global_transform.origin, ) * 0.8
			laser_child.global_transform = laser_child.global_transform.looking_at(laser_child.global_transform.origin - \
			(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
			player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
			laser_child.global_transform.origin).normalized(), Vector3.FORWARD)
		await get_tree().create_timer(randf_range(0.125,0.20)).timeout
func enemy5_attack():
	var enemy = $EnemyShip5Path/PathFollow3D/EnemyShip5
	enemy5_attack_start = true
	for count in range(0,29):
		var distance_between = enemy.global_transform.origin.distance_to(player.global_transform.origin)
		var forward_offset = 74 * Global.forward_speed + distance_between * 0.25
		var other_offset = Vector3(randf_range(-6.0,6.0),randf_range(-6.0,6.0),0)
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.speed_multiplier = 2.0
		enemy_missile.global_position = enemy.global_position
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
		player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
		enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
		await get_tree().create_timer(randf_range(0.45,0.6)).timeout
func final_attack(enemyship):
	var enemy = enemyship
	for count in range(0,37):
		if randf_range(1,1) < 0.8:
			var distance_between = enemy.global_transform.origin.distance_to(player.global_transform.origin)
			var forward_offset = 20 * Global.forward_speed + distance_between * 0.2
			var other_offset = Vector3(randf_range(-10.0,10.0),randf_range(-6.0,6.0),0)
			var enemy_missile = missile.instantiate()
			add_child(enemy_missile)
			enemy_missile.speed_multiplier = 4.0
			enemy_missile.global_position = enemy.global_position
			enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
			(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
			player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
			enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)
			await get_tree().create_timer(randf_range(0.4,0.8)).timeout
		else:
			for count2 in range(0,randi_range(1,2)):
				var forward_offset = pow(count,1.1) * 2.25 + 20 + randf_range(0,1)
				var other_offset = Vector3(0,randf_range(-4,6.0) - count/5 * 0,0)
				var enemy_laser = laser.instantiate()
				add_child(enemy_laser)
				var laser_child = enemy_laser.laser_beam
				laser_child.global_position = enemy.global_position
				#enemy_laser.global_position = enemy.global_position + enemy.global_transform.looking_at(enemy.global_transform.origin - player.global_transform.origin, ) * 0.8
				laser_child.global_transform = laser_child.global_transform.looking_at(laser_child.global_transform.origin - \
				(player.global_transform.origin + player.global_transform.basis.z * forward_offset + \
				player.global_transform.basis.x * other_offset.x + player.global_transform.basis.y * other_offset.y - \
				laser_child.global_transform.origin).normalized(), Vector3.FORWARD)
			await get_tree().create_timer(randf_range(0.1,0.125)).timeout

func _toggle_particles():
	if Global.options_particles:
		player.thrustersmain.emitting = true

	else:
		player.thrustersmain.emitting = false
		player.thrustersleft.emitting = false
		player.thrustersright.emitting = false

func _toggle_graphics():
	if Global.options_graphics:
		environment.environment.sdfgi_enabled = true
		for meshes in multimeshes.get_children():
			meshes.visible = true
	else:
		environment.environment.sdfgi_enabled = false
		for meshes in multimeshes.get_children():
			meshes.visible = false
