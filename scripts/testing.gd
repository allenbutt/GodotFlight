extends Node3D

var missile = preload("res://scenes/enemy_missile.tscn")
@onready var player = $Window/Player3D

func _ready():
	pass # Replace with function body.


func _process(delta):
	missile_spawn()

func missile_spawn():
	if randi_range(0,100) == 1:
		var enemy_missile = missile.instantiate()
		add_child(enemy_missile)
		enemy_missile.missile.global_position = player.global_position + Vector3(randf_range(10,15),randf_range(5,15),randf_range(-5,5))
		enemy_missile.missile.global_transform = enemy_missile.missile.global_transform.looking_at(enemy_missile.missile.global_transform.origin - \
		(player.global_transform.origin - enemy_missile.missile.global_transform.origin).normalized(), Vector3.UP)

