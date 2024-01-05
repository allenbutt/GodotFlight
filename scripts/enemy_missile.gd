extends Node3D

var velocity = Vector3.FORWARD

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_global_transform().basis.z)
	#transform.origin += transform.basis.z * delta
#	var aim = global_transform.basis
#	print(aim)
#	#print($Missile.position.z)
	$Missile.rotation.z += 0.1
	global_position += 0.075 * velocity
##	if $Missile.position.z > 20:
##		$Missile.position.z = 0.0
