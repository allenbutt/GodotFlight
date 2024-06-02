extends Node3D

var speed = 0.3
var velocity = Vector3.FORWARD
@export var missile: Node3D
var missile_exploding = false

var explosion = preload("res://scenes/explosion.tscn")

var speed_multiplier = 1.0

var player_target

@onready var audioplayer1 = $Missile/LaunchSound1
@onready var audioplayer2 = $Missile/LaunchSound2
@onready var audioplayer3 = $Missile/LaunchSound3
@onready var audioplayer4 = $Missile/LaunchSound4

func _ready():
	match randi_range(2,4):
		1:
			audioplayer1.pitch_scale = randf_range(0.25, 0.55)
			audioplayer1.play()
		2:
			audioplayer2.pitch_scale = randf_range(0.5, 1.0)
			audioplayer2.play(0.1)
		3:
			audioplayer3.pitch_scale = randf_range(0.5, 1.0)
			audioplayer3.play(0.12)
		4:
			audioplayer4.pitch_scale = randf_range(0.5, 1.0)
			audioplayer4.play(0.08)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if missile_exploding == false:
		velocity = missile.global_transform.basis.z
		missile.global_position += speed * speed_multiplier * velocity * delta * 60


func _on_area_3d_body_entered(body):
	missile_exploding = true
	var explode = explosion.instantiate()
	explode.position = missile.position
	explode.distance_to_player = missile.global_transform.origin.distance_to(player_target.global_transform.origin)
	add_child(explode)
	end_movement()
	await get_tree().create_timer(2.0).timeout
	queue_free()

func end_movement():
	$Missile/Model.visible = false
	$Missile/Model2.visible = false
	$Missile/TargetLaser.visible = false
	#$GPU_Particles.emitting = false
	#$GPU_Flame.emitting = false
	#$Area3D.monitoring = false
	#$Area3D.monitorable = false
	
func remove_targeting():
	$Missile/TargetLaser.visible = false
