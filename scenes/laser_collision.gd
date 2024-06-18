extends Area3D

var damage = Global.damage_laser
signal player_hit_signal()

func damage_value():
	return(damage)

func player_hit(player_character):
	player_hit_signal.emit(player_character)
