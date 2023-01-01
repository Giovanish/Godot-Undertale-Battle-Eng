extends Node2D

export var polyspeed = 5

func shoot_poly(blue := false):
	var rng = RandomNumberGenerator.new()
	var poly = $Polygon.duplicate()
	poly.set_script(load("res://attacks/polyatk/Polygon.gd"))
	poly.speed = polyspeed
	poly.show()
	rng.randomize()
	if not blue:
		var value = rng.randi_range(1,2)
		if value == 1 and polyspeed != 1.75:
			poly.get_node("DmgBox").color = "norm"
		else:
			poly.get_node("DmgBox").color = "still"
	add_child(poly)

func _ready():
	for box in get_tree().get_nodes_in_group("dmgbox"):
		if box.emy_index == 0:
			box.damage = get_tree().current_scene.get_node("Enemies").enemies["Mr. Poly"].DMG
	$Timer.start()

func _on_Timer_timeout():
	shoot_poly()
	var rng = RandomNumberGenerator.new()
