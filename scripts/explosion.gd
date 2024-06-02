extends Node3D

var distance_to_player = 0.0
signal explosionshake()

func _ready():
	explode()


func explode():
	remove_screenshake_hitbox()
	$Node3D/ParticlesExplosionCloud.emitting = true
	$Node3D/ParticlesExplosionCloud2.emitting = true
	$Node3D/ParticlesExplosionCloud3.emitting = true
	$Node3D/GPU_Shockwave.emitting = true
	$Node3D/GPU_Particles.emitting = true
	var randstart = 0.00
	$ExplodeSound1.pitch_scale = randf_range(0.7,1.0)
	$ExplodeSound1.play()
	if distance_to_player > 20.0:
		$ExplodeSound2.pitch_scale = randf_range(0.25,0.50)
		$ExplodeSound2.play()
	if randi_range(0,3) == 0:
		randstart = 0
	elif randi_range(0,2) == 0:
		randstart = 2.98
	else:
		randstart = 8.02
	$ExplodeSound3.pitch_scale = randf_range(0.33,0.67)
	$ExplodeSound3.play(randstart)
	await get_tree().create_timer(5.0).timeout
	$ExplodeSound3.stop()
	await get_tree().create_timer(5.0).timeout
	queue_free()

func remove_screenshake_hitbox():
	await get_tree().create_timer(0.0625).timeout
	$Node3D/Area3D2/CollisionShape3D.disabled = true
