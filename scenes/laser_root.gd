extends Node3D
@export var laser_beam: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Laser_Launch.pitch_scale = randf_range(0.25,0.75)
	$Laser_Launch.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
