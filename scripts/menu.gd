extends Control

signal BeginGame()

func _ready():
	pass



func _process(delta):
	pass



func _on_button_start_pressed():
	BeginGame.emit()
	print("signal")


func _on_button_particles_pressed():
	Global.options_particles = not Global.options_particles


func _on_button_screenshake_pressed():
	Global.options_screenshake = not Global.options_screenshake


func _on_button_graphics_pressed():
	Global.options_graphics = not Global.options_graphics


func _on_button_sound_pressed():
	Global.options_sound = not Global.options_sound


func _on_button_music_pressed():
	Global.options_music = not Global.options_music
