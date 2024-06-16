extends AudioStreamPlayer3D

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
