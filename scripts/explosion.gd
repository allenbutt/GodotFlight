extends Node3D


func _ready():
	explode()


func explode():
	$Node3D/ParticlesExplosionCloud.emitting = true
	$Node3D/ParticlesExplosionCloud2.emitting = true
	$Node3D/ParticlesExplosionCloud3.emitting = true
	$Node3D/GPU_Shockwave.emitting = true
	$Node3D/GPU_Particles.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
