extends Node

onready var menu = get_parent().get_node("Menu")
onready var hp = get_parent().get_node("HUD/Health/HealthBG/HealthCover")

var ssitem : String
var healtxt : String

signal finished

func activate(sitem : String):
	ssitem = sitem
	menu.activeset(false)
	if "B" in sitem:
		match sitem:
			"Bisicle":
				heal(11,3)
				menu.text.type("* You drive.{p}{}* You then eat the bike handle.{}{p}" + gethtxt())
				yield(menu.text,"typefin")
				Stats.OWitems.insert(Stats.OWitems.find(ssitem),"Spoke")
				reset()
	if "C" in sitem:
		match sitem:
			"Cherries":
				menu.text.type("* You ate both the cherries.{p}{}* You feel your life increase{}  by twicemore...")
				yield(menu.text,"typefin")
				heal(hp.value)
				menu.text.type(gethtxt())
				yield(menu.text,"typefin")
				reset()
	if "P" in sitem:
		match sitem:
			"Pie":
				menu.text.type("* Butterscotch-cinnamon pie, one{}  slice.{}{p}* Your HP was maxed out.")
				heal(Stats.maxhealth)
				yield(menu.text,"typefin")
				reset()
	if "S" in sitem:
		match sitem:
			"Spoke":
				menu.text.type("* All that's left from the{}  wreckage was a single bike{}  spoke.{p} It tastes alright.")
				yield(menu.text,"typefin")
				heal(8)
				menu.text.type(gethtxt())
				yield(menu.text,"typefin")
				reset()
	if "T" in sitem:
		match sitem:
			"T. Dinner":
				heal(17,1.75)
				menu.text.type("* You eat the breast and save{}  the drumsticks.{p}{}" + gethtxt())
				yield(menu.text,"typefin")
				Stats.inventory += ["T. Leg", "T. Leg"]
				reset()
			"T. Leg":
				heal(8)
				menu.text.type("* You slerp it right off the{}  bone.{p}{}" + gethtxt())
				yield(menu.text,"typefin")
				reset()

	if "U" in sitem:
		match sitem:
			"Urchin":
				menu.text.type("* You ate an urchin.{p}{}* You lost 10 HP.{p}{}* What did you expect?")
				heal(-10)
				yield(menu.text,"typefin")
				reset()

func reset():
	menu.curlist.coord = Vector2(1,1)
	menu.curlist.page = 0
	Stats.inventory.remove(Stats.inventory.find(ssitem))
	Stats.translate_items(true)
	menu.cdepth = -1
	menu.curlist.update()
	print(Stats.OWitems)
	emit_signal("finished")

var healing
var hp_change
var timeoff : float
var snd

func heal(health,time_offset = 0, sound = true):
	hp_change = health
	healing = true
	timeoff = time_offset
	snd = sound
	yield(get_tree().create_timer(time_offset),"timeout")
	if healing == true:
		if sound:
			if health < 0:
				$HitSnd.play()
			if health > 0:
				$HealSnd.play()
		hp.value += health
		healing = false

func gethtxt(asterisk = true, txt1 = "You recovered " + str(hp_change) + " HP!", txt2 = "Your HP was maxed out.") -> String:
	if not asterisk:
		if hp.value + hp_change >= Stats.maxhealth:
			healtxt = txt2
		else:
			healtxt = txt1
	else:
		if hp.value + hp_change >= Stats.maxhealth:
			healtxt = "* " + txt2
		else:
			healtxt = "* " + txt1
	return healtxt

func _process(delta):
	if timeoff > 0:
		if healing == true:
			if Input.is_action_just_pressed("x"):
				if snd:
					if hp_change < 0:
						$HitSnd.play()
					if hp_change > 0:
						$HealSnd.play()
				hp.value += hp_change
				healing = false
