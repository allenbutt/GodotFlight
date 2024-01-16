extends Node3D

var speed = 0.3
var velocity = Vector3.FORWARD
@export var missile: Node3D
var missile_exploding = false

var explosion = preload("res://scenes/explosion.tscn")

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if missile_exploding == false:
		velocity = missile.global_transform.basis.z
		missile.global_position += speed * velocity * delta * 60


func _on_area_3d_body_entered(body):
	missile_exploding = true
	var explode = explosion.instantiate()
	explode.position = missile.position
	add_child(explode)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func end_movement():
	$Missile/Model.visible = false
	$Missile/Model2.visible = false
	$Missile/TargetLaser.visible = false
	$GPU_Particles.emitting = false
	$GPU_Flame.emitting = false
	$Area3D.monitoring = false
	$Area3D.monitorable = false
	
