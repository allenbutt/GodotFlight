extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var beam_particles = $LaserParticles
@onready var beam_particle_blocker = $GPUParticlesCollisionBox3D

func _ready():
	pass


func _process(delta):
	#pass
	var cast_point
	force_raycast_update()
	cast_point = transform * (Vector3.FORWARD * 150) *-1
#	if is_colliding():
#		cast_point = to_local(get_collision_point())
#	else:
#		cast_point = transform * (Vector3.FORWARD * 50)
	beam_mesh.mesh.height = cast_point.y
	beam_mesh.position.y = cast_point.y/2
	beam_particle_blocker.position.y = cast_point.y
	
	beam_particles.position.y = cast_point.y/2
	var particle_amount = snapped(abs(cast_point.y) * 50,1)
	if particle_amount > 1:
		beam_particles.amount = particle_amount
	else:
		beam_particles.amount = 1
	
	beam_particles.process_material.set_emission_box_extents(
		Vector3(beam_mesh.mesh.top_radius, abs(cast_point.y)/2, beam_mesh.mesh.top_radius))
		
