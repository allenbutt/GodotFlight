extends Node3D

var random_velocity_max = 1
var random_sideways_max = 2.0

func _ready():
	Engine.time_scale = 0.25
	await get_tree().create_timer(0.05).timeout
	for pieces in self.get_children():
		var velocity = pieces.global_transform.basis.z.normalized() + pieces.global_transform.basis.x * randf_range(random_sideways_max*-1,random_sideways_max)
		pieces.apply_central_impulse(velocity * random_velocity_max)
