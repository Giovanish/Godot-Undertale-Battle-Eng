extends Node2D

var options = false
var cdepth := -1

var itemposx := [-248,7]
var itemposy := [46,79,110]

var curlist : ItemList
var active := true

onready var enemy = get_parent().get_node("Enemies")

onready var text = $Box/Menutext
onready var spre = $Options/Mercy/Optlist
onready var soul = get_parent().get_node("Soul")

signal cdepth_change(depth, button)
signal buttons
signal monsterturn
signal monsterscene

var items_selected := []
var just_selected : String
var incr

func getsel(offset = 0):
	if incr:
		items_selected += [just_selected]
	if items_selected.size() - 1 >= 0:
		return items_selected[(items_selected.size() - 1) - offset]

func _ready():
	get_parent().get_node("Enemies/Mr Poly/Smoke").texture.current_frame = 0
	emit_signal("buttons")
#	"buttons" gives the the player the turn.
#	"monsterscene" gives the enemy the turn.
	for list in get_tree().get_nodes_in_group("optlist"):
		list.set_process(false)
		list.hide()

func _on_Buttons_pressed(focus):
	snd("SelectSnd").play()
	match focus:
		0:
			if enemy.enemies_alive.size() > 0:
				select_list($Options/Fight/Monlist)
				maxdepth = 0
				cdepth = 0
			else:
				cdepth = -1
		1: 
			if enemy.enemies_alive.size() > 0:
				select_list($Options/Act/Monlist)
				maxdepth = 2
				cdepth = 0
			else:
				cdepth = -1
		2:
			if Stats.inventory.size() > 0:
				select_list($Options/Items/Inventory)
				maxdepth = 0
				cdepth = 0
			else:
				cdepth = -1
		3:	
			select_list($Options/Mercy/Optlist)
			maxdepth = 0
			cdepth = 0

func _on_Menu_cdepth_change(depth,button,increasing):
		incr = increasing
		if cdepth >= maxdepth:
			cdepth = maxdepth
		if increasing == true:
			if curlist != $Options/Items/Inventory:
				select()
				just_selected = curlist.get_item_text(curlist.get_selected_items()[0])
				just_selected = just_selected.replace("* ","")
				just_selected = just_selected.replace("[color=" + Global.bristrcolor + "]","")
				just_selected = just_selected.replace("[/color]","")
				
			else:
				item_select()
				just_selected = curlist.get_item_text(curlist.get_selected_items()[0])
				just_selected = just_selected.replace("* ","")
				just_selected = just_selected.replace("[color=" + Global.bristrcolor + "]","")
				just_selected = just_selected.replace("[/color]","")
		match button:
			0:
				if cdepth == 0:
					select_list($Options/Fight/Monlist)
				if increasing == true:
					activeset(false)
					var atkscreen = preload("res://fight/AttackScreen.tscn").instance().duplicate()
					var weapon = load("res://fight/" + Stats.weapon.to_lower() + "/" + Stats.weapon + ".tscn").instance().get_node("Weapon").duplicate()
	
					get_parent().add_child(atkscreen)
					yield(atkscreen, "finished")
					
					if not atkscreen.output_dmg <= 0:
						enemy.get_node(getsel().replace(".","") + "/Other").add_child(weapon)
						weapon.get_node("Sprite").position = enemy.get_node(getsel().replace(".","") + "/Other/WeaponPos").position
						yield(weapon.get_node("Anim"),"animation_finished")
						weapon.get_parent().get_node("HealthBar").bounce()
					else:
						weapon.hide()
						enemy.get_node(getsel().replace(".","") + "/Other").add_child(weapon)
						weapon.get_parent().get_node("HealthBar").bounce()
					yield(weapon.get_parent().get_node("HealthBar"),"finished")
					enemy.moncheck()
					if enemy.enemies_alive != []:
						emit_signal("monsterscene")
						cdepth = -1
					else:
						get_parent().end_battle()
					for mon in enemy.enemies_killed:
						if enemy.enemies[getsel()].HP <= 0:
							enemy.dust(getsel().replace(".",""))
					for node in get_tree().get_nodes_in_group("atkscrchild"):
						node.queue_free()
					for node in get_tree().get_nodes_in_group("monhpbar"):
						node.hide()
					
			1:
				match cdepth:
					0:
						select_list($Options/Act/Monlist)
					1: 
						if curlist.get_selected_items().size() > 0:
							if getsel() == "Mr. Poly":
								select_list($"Options/Act/Mr Poly")
							elif getsel() == "Real Soul":
								select_list($"Options/Act/Real Soul")
					2:
						get_parent().get_node("ActSystem").activate(getsel(),getsel(2))
			2:
				if cdepth == 0:
					select_list($Options/Items/Inventory)
				if increasing == true:
					get_parent().get_node("ItemSystem").activate(Stats.inventory[curlist.get_selected_items()[0]])
					yield(get_parent().get_node("ItemSystem"),"finished")
					emit_signal("monsterscene")
			3:
				if cdepth == 0:
					if increasing == true:
						activeset(false)
						match getsel():
							"Spare":
								curlist.spareall()
								if enemy.enemies_alive.size() == 0:
									get_parent().end_battle()
								else:
									emit_signal("monsterscene")
							"Flee":
								get_parent().flee()

var maxdepth := 1

func activeset(value):
	if value == false:
		for button in $Buttons.get_children():
			button.frame = 0
	for list in get_tree().get_nodes_in_group("optlist"):
		list.set_process(false)
		list.hide()
	active = value
	soul.visible = value

func snd(sound):
	return get_node("Sounds/" + sound)

func _process(delta):
	$Options/Fight/Monlist.update_bars()
	if active == true and options == true:
		if curlist.get_item_count() != 1:
			if curlist.is_in_group("monlist") or curlist == $Options/Mercy/Optlist:
				if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
					snd("FocusSnd").play()
				if curlist.get_item_count() > 3:
					if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
						snd("FocusSnd").play()
			else:
				if curlist != $Options/Items/Inventory:
					if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
						snd("FocusSnd").play()
					if curlist.get_item_count() > 2:
						if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
							snd("FocusSnd").play()
				else:
						if Input.is_action_just_pressed("right") and curlist.sectsize != 1:
							snd("FocusSnd").play()
						if Input.is_action_just_pressed("left"):
							snd("FocusSnd").play()
						if curlist.sectsize > 2:
							if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
								snd("FocusSnd").play()
		if Input.is_action_just_pressed("z"):
			if not Input.is_action_just_pressed("x"):
				snd("SelectSnd").play()
				cdepth += 1
				emit_signal("cdepth_change",cdepth,$Buttons.focus,true)
		if Input.is_action_just_pressed("x"):
			if not Input.is_action_just_pressed("z"):
				if cdepth != -1:
					snd("SelectSnd").play()
					cdepth -= 1
					if cdepth == -1:
						options = false
						for list in get_tree().get_nodes_in_group("optlist"):
							list.set_process(false)
							list.hide()
						emit_signal("buttons")
				else:
					cdepth = -1
				emit_signal("cdepth_change",cdepth,$Buttons.focus,false)

func select(monlist := false, pickable := false):
	match pickable:
		false:
			if curlist.is_in_group("monlist") or curlist == $Options/Mercy/Optlist:
				match curlist.coord:
					Vector2(1,1):
						curlist.select(0)
					Vector2(1,2):
						curlist.select(1)
					Vector2(1,3):
						curlist.select(2)
					Vector2(2,1):
						curlist.select(3)
					Vector2(2,2):
						curlist.select(4)
					Vector2(2,3):
						curlist.select(5)
			else:
				match curlist.coord:
					Vector2(1,1):
						curlist.select(0)
					Vector2(2,1):
						curlist.select(1)
					Vector2(1,2):
						curlist.select(2)
					Vector2(2,2):
						curlist.select(3)
					Vector2(3,1):
						curlist.select(4)
					Vector2(3,2):
						curlist.select(5)
		true:
			if monlist:
				match curlist.coord:
					Vector2(1,1):
						curlist.select(0)
					Vector2(1,2):
						curlist.select(1)
					Vector2(1,3):
						curlist.select(2)
					Vector2(2,1):
						curlist.select(3)
					Vector2(2,2):
						curlist.select(4)
					Vector2(2,3):
						curlist.select(5)
			else:
				match curlist.coord:
					Vector2(1,1):
						curlist.select(0)
					Vector2(2,1):
						curlist.select(1)
					Vector2(1,2):
						curlist.select(2)
					Vector2(2,2):
						curlist.select(3)
					Vector2(3,1):
						curlist.select(4)
					Vector2(3,2):
						curlist.select(5)

func item_select():
	match curlist.coord:
		Vector2(1,1):
			curlist.select(0 + (curlist.page * curlist.psize))
		Vector2(2,1):
			curlist.select(1 + (curlist.page * curlist.psize))
		Vector2(1,2):
			curlist.select(2 + (curlist.page * curlist.psize))
		Vector2(2,2):
			curlist.select(3 + (curlist.page * curlist.psize))

func select_list(node : Node):
	options = true
	curlist = node
	text.type("")
	node.set_process(true)
	node.show()
	for list in get_tree().get_nodes_in_group("optlist"):
		if list != node:
			list.set_process(false)
			list.hide()

func is_selected(item):
	var selected : bool = "* " + item == curlist.get_item_text(curlist.get_selected_items()[0])
	return selected


func _on_Menu_buttons():
	$Box/Menutext.show()
	$Box.margin_left = -288
	$Box.margin_top = 10
	$Box.margin_right = 287
	$Box.margin_bottom = 150
