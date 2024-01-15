extends Node3D

var speed = 0.3
var velocity = Vector3.FORWARD
@export var missile: Node3D

var explosion = preload("res://scenes/explosion.tscn")

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = missile.global_transform.basis.z
	missile.global_position += speed * velocity * delta * 60


func _on_area_3d_body_entered(body):
	var explode = explosion.instantiate()
	explode.global_position = missile.global_position
	add_child(explode)
	await get_tree().create_timer(2.0).timeout
	queue_free()
