extends Node3D
@export var laser_beam: Node3D
var explosion = preload("res://scenes/explosion.tscn")
@onready var laser_mesh = $LaserParent/LaserMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	$LaserParent/Area3D.player_hit.connect(check_line)

func check_line(target_player):
	var target = target_player
	var zdistancemax = 200.0
	for zdistance in range(zdistancemax*0.1,zdistancemax*.9, 1.0):
		var myMesh = MeshInstance3D.new()
		myMesh.mesh = BoxMesh.new()
		myMesh.position = laser_beam.position + laser_beam.basis.z * zdistance * laser_mesh.mesh.height/zdistancemax
		add_child(myMesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
