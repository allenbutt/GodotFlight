extends AudioStreamPlayer3D



func _ready():
	pass


func _on_timer_timeout():
	queue_free()
