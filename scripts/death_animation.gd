extends Node3D

var random_velocity_max = 0.5
var random_sideways_max = 1.25

@onready var glider_pieces = $GliderPieces

func _ready():
	await get_tree().create_timer(0.05).timeout
	$ParticlesExplosionCloud.emitting = true
	$Death_Sound.play()
	for pieces in glider_pieces.get_children():
		var velocity = pieces.global_transform.basis.z.normalized() + pieces.global_transform.basis.x * randf_range(random_sideways_max*-1,random_sideways_max) + \
		pieces.global_transform.basis.y * randf_range(0,random_sideways_max)
		pieces.apply_central_impulse(velocity * random_velocity_max)
