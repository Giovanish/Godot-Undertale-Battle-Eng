extends Node2D

onready var menu = get_parent().get_node("Menu")
onready var asyst = get_parent().get_node("ActSystem")

var enemies = {
	"Mr. Poly" :
		{"docile" : false, "DMG" : 3, "DF" : 3,"HP" : 100, "MAX_HP" : 100, "EXP" : 52, "GLD" : 68},
	"Real Soul" :
		{"docile" : false, "DMG" : 5, "DF" : 10, "HP" : 20, "MAX_HP" : 20, "EXP" : 100, "GLD" : 99}
	}

var enemies_alive = enemies.keys()
var enemies_killed = []

signal typefin
signal rtypefin
signal enemcheck

func _process(delta):
	for hpbar in get_tree().get_nodes_in_group("monhpbar"):
		hpbar.max_value = enemies[hpbar.hp_hint].MAX_HP

func docile(monster):
	enemies[monster]["docile"] = true

func get_dociles() -> Array:
	var spares = []
	for mon in enemies:
		if enemies[mon]["docile"] == true:
			spares += [mon]
	return spares

func _input(event):
	if Input.is_action_just_pressed("z"):
		emit_signal("typefin")

var talking := false

func montalk(mon : Node):
	if mon.get_node("Other/Bubble") != null:
		talking = true
		mon.get_node("Other/Bubble").show()
		return mon.get_node("Other/Bubble/Speech")

func mon(mon : Node):
	return mon.get_node("Other")

func moncheck():
	for mon in enemies_alive:
		if enemies[mon].HP <= 0:
			enemies[mon]["docile"] = false
			print(get_node(menu.getsel().replace(".","")))
			enemies_killed += [menu.getsel()]
			enemies_alive.remove(enemies_alive.find(menu.getsel()))
			for monlist in get_tree().get_nodes_in_group("monlist"):
				monlist.update()
				monlist.coord = Vector2(1,1)
				menu.get_node("Options/Mercy/Optlist").update()

func _on_Menu_monsterscene():
	yield(get_parent(),"scene")
	if mon($"Mr Poly") != null:
		if not "Mr. Poly" in get_dociles():
			if asyst.married == true and menu.getsel() == "Marry":
				montalk($"Mr Poly").btype("You did this, honey.")
			else:
				montalk($"Mr Poly").btype("I'm a blank slate.")
		
	if mon($"Real Soul") != null:
		montalk($"Real Soul").btype("(silent protagonist)")
	if enemies_alive == []:
		get_parent().end_battle()
	else:
		if talking == true:
			finscene()
		else:
			finscene(false)

func dust(mon):
	get_node("Sounds/DustingSnd").play()
	get_node(mon + "/Other").queue_free()
	get_node(mon).get_node("Dust").emitting = true
	get_node(mon).get_node("Dust").speed_scale = 0
	yield(get_tree().create_timer(0.0),"timeout")
	get_node(mon).get_node("Dust").speed_scale = 0.8
	get_node(mon).self_modulate.a = 0

func finscene(yielding = true):
	if yielding:
		yield(self,"typefin")
		talking = false
		menu.emit_signal("monsterturn")
		emit_signal("rtypefin")
	else:
		talking = false
		menu.emit_signal("monsterturn")
		emit_signal("rtypefin")


func _on_Enemies_rtypefin():
	if mon($"Mr Poly") != null:
		$"Mr Poly/Other/Bubble".hide()
	if mon($"Real Soul") != null:
		$"Real Soul/Other/Bubble".hide()

func spare(node: Node):
	get_node("Sounds/DustingSnd").play()
	node.modulate.a = 0.5
	node.get_node("Smoke").emitting = true
	node.get_node("Smoke").texture.current_frame = 10
	node.get_node("Other").queue_free()

func _on_Optlist_spared():
	for mon in get_dociles():
		enemies[mon]["docile"] = false
		if mon == "Mr. Poly":
			spare($"Mr Poly")
		else:
			spare(get_node(mon))
		enemies_alive.remove(enemies_alive.find(mon))
		for monlist in get_tree().get_nodes_in_group("monlist"):
			monlist.update()
			monlist.coord = Vector2(1,1)
			menu.get_node("Options/Mercy/Optlist").update()
