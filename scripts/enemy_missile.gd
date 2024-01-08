extends Node3D

var speed = 0.3
var velocity = Vector3.FORWARD
@export var missile: Node3D

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = missile.global_transform.basis.z
	missile.global_position += speed * velocity * delta * 60
