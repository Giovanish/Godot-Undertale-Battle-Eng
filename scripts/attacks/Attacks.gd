extends Node2D

export(bool) var uniform_dmg
export(bool) var uniform_inv
export(int) var defdmg
export(float) var definv

export(bool) var uniform_colors

export(Color) var defwhite = Color("ffffff")
export(Color) var defblue = Color("00fffb")
export(Color) var deforange = Color("ffb500")
export(Color) var defgreen = Color("00ff00")

onready var attack : NodePath
onready var enemy = get_parent().get_node("Enemies")
onready var soul = get_parent().get_node("Soul")
onready var menu = get_parent().get_node("Menu")

var attlog = load("res://attacks/AttackLibrary.tscn").instance()
var attbox : String

func _ready():
	for att in get_tree().get_nodes_in_group("attack"):
		att.hide()

func _process(delta):
	if uniform_dmg == true:
		for box in get_tree().get_nodes_in_group("dmgbox"):
			if not box.is_in_group("dmgbox(dmg)"):
				box.damage = defdmg
	if uniform_inv == true:
		for box in get_tree().get_nodes_in_group("dmgbox"):
			if not box.is_in_group("dmgbox(inv)"):
				box.inv_frames = definv
	if uniform_colors == true:
		for box in get_tree().get_nodes_in_group("dmgbox"):
			box.white = defwhite
			box.blue = defblue
			box.orange = deforange
			box.green = defgreen

func _on_Menu_monsterturn():
	if enemy.enemies_alive != []:
		var atk = attlog.get_node_or_null(attack).duplicate()
		add_child(atk)
		yield(menu,"buttons")
		for child in get_children():
			if child.is_in_group("attack"):
				child.queue_free()

func load_attack(att : Node):
	att.show()
	att.activate()
	for att2 in get_tree().get_nodes_in_group("attack"):
		if att2 != att:
			att2.hide()

func att(att : NodePath, box = null, time = null):
	if enemy.enemies_alive != []:
		attack = att
		if box != null and box != "":
			get_parent().play(box)
		if time != null:
			get_parent().turntime = time

func _on_Menu_monsterscene():
	if enemy.enemies_alive.size() == 2 or enemy.enemies_alive == ["Real Soul"]:
		if "Mr. Poly" in enemy.get_dociles():
			attlog.get_node("PSAttack 1/PolyAttack 1").polyspeed = 1.75
			att("PSAttack 1","squarebox",9)
			soul.color = "blue"
			yield(menu,"buttons")
			soul.color = "red"
		else:
			attlog.get_node("PSAttack 1/PolyAttack 1").polyspeed = 5
			att("PSAttack 1","squarebox",6)
			
	elif enemy.enemies_alive == ["Mr. Poly"]:
		if "Mr. Poly" in enemy.get_dociles():
			attlog.get_node("PSAttack 1/PolyAttack 1").polyspeed = 1.3
			att("PSAttack 1/PolyAttack 1","squarebox",9)
			soul.color = "blue"
			yield(menu,"buttons")
			soul.color = "red"
		else:
			att("PolyAttack 2","squarebox",10)
