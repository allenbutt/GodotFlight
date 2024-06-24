extends Control

signal BeginGame()
signal ToggleParticles()
signal ToggleGraphics()
signal ToggleMusic()
signal ToggleSound()
signal SaveOptions()

@onready var buttonparticles = $AspectRatioContainer/Panel/OptionsContainerMargin/MarginContainer/OptionsContainer/ButtonParticles
@onready var buttonscreenshake = $AspectRatioContainer/Panel/OptionsContainerMargin/MarginContainer/OptionsContainer/ButtonScreenshake
@onready var buttongraphics = $AspectRatioContainer/Panel/OptionsContainerMargin/MarginContainer/OptionsContainer/ButtonGraphics
@onready var buttonsound = $AspectRatioContainer/Panel/OptionsContainerMargin/MarginContainer/OptionsContainer/ButtonSound
@onready var buttonmusic = $AspectRatioContainer/Panel/OptionsContainerMargin/MarginContainer/OptionsContainer/ButtonMusic
@onready var click_sound = $sfx_click_button
@onready var highlight_sound = $sfx_highlight_button

func _ready():
	pass

func set_label_text():
	SaveOptions.emit()
	if Global.options_particles:
		buttonparticles.text = "Particles: On"
	else:
		buttonparticles.text = "Particles: Off"
	if Global.options_screenshake:
		buttonscreenshake.text = "Screenshake: On"
	else:
		buttonscreenshake.text = "Screenshake: Off"
	if Global.options_graphics:
		buttongraphics.text = "Graphics: Normal"
	else:
		buttongraphics.text = "Graphics: Reduced"
	if Global.options_sound:
		buttonsound.text = "Sound: On"
	else:
		buttonsound.text = "Sound: Off"
	if Global.options_music:
		buttonmusic.text = "Music: On"
	else:
		buttonmusic.text = "Music: Off"

func _on_button_start_pressed():
	BeginGame.emit()
	click_sound.play()


func _on_button_particles_pressed():
	Global.options_particles = not Global.options_particles
	set_label_text()
	ToggleParticles.emit()
	click_sound.play()


func _on_button_screenshake_pressed():
	Global.options_screenshake = not Global.options_screenshake
	set_label_text()
	click_sound.play()


func _on_button_graphics_pressed():
	Global.options_graphics = not Global.options_graphics
	set_label_text()
	ToggleGraphics.emit()
	click_sound.play()


func _on_button_sound_pressed():
	Global.options_sound = not Global.options_sound
	set_label_text()
	ToggleSound.emit()
	click_sound.play()


func _on_button_music_pressed():
	Global.options_music = not Global.options_music
	set_label_text()
	ToggleMusic.emit()
	click_sound.play()


func _on_button_mouse_entered():
	highlight_sound.play()
