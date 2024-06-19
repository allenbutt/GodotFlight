extends Node3D
@export var laser_beam: Node3D
@onready var laser_mesh = $LaserParent/LaserMesh
@onready var laser_sound = $Laser_Persistent_Sound

# Called when the node enters the scene tree for the first time.
func _ready():
	$LaserParent/Area3D.player_hit_signal.connect(check_line)

#Need a function to check along a laser's path to see what point is closest to the player.
#This function is triggered by a player collision area that searches specifically for
#lasers. It checks points along the laser and compares distances to find the shortest distance.
#Note that it is not looking for the shortest distance to the player, but rather the shortest
#distance to a node offset forward from the player. Finally, the active laser sound effect is played
#only from the spot with the shortest distance.
func check_line(target_player):
	var target = target_player
	var zdistancemax = 200.0
	var saved_distance = 1000.0
	var create_point
	for zdistance in range(zdistancemax * 0.1,zdistancemax * .9, 1.0):
		var pointinquestion = laser_beam.position + laser_beam.basis.z * zdistance * laser_mesh.mesh.height/zdistancemax
		if pointinquestion.distance_to(target.global_transform.origin) < saved_distance:
			saved_distance = pointinquestion.distance_to(target.global_transform.origin)
			create_point = pointinquestion
	laser_sound.position = create_point
	laser_sound.play()
	#Debugging, creating a box at the nearest point
	#var myMesh = MeshInstance3D.new()
	#myMesh.mesh = BoxMesh.new()
	#myMesh.position = create_point
	#myMesh.scale = Vector3(1.0, 1.0, 1.0)
	#add_child(myMesh)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
