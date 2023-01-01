extends Control

signal finished

var weapbar = load("res://fight/" + Stats.weapon.to_lower() + "/" + Stats.weapon + ".tscn").instance().get_node("BarNode").duplicate()
var output_dmg : int

func _ready():
	add_child(weapbar)
	yield(weapbar, "finished")
	if weapbar.atk_multiplier != -1:
		output_dmg = Stats.atk + (Stats.baseatk * weapbar.atk_multiplier)
	else:
		output_dmg = 0
	emit_signal("finished")

