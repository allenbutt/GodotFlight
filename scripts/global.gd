extends Node

var alive = true
var forward_speed = 0.115
var forward_speed_base = 0.115
#standard 0.125
var player_health = 200.0
var player_shield = 50.0
var damage_terrain = 25.0
var damage_tree = 35.0
var damage_explode = 40.0
var damage_laser = 35.0
var moving = false
var victory = false

var options_particles = true
var options_screenshake = true
var options_graphics = true
var options_sound = true
var options_music = true

var best_time = 0.00

func reset_global_variables():
	alive = true
	forward_speed = 0.115
	forward_speed_base = 0.115
	#standard 0.125
	player_health = 200.0
	player_shield = 50.0
	damage_terrain = 25.0
	damage_tree = 35.0
	damage_explode = 40.0
	damage_laser = 35.0
	moving = false
	victory = false

	options_particles = true
	options_screenshake = true
	options_graphics = true
	options_sound = true
	options_music = true
