extends Node

onready var menu = get_parent().get_node("Menu")
onready var text = menu.text
onready var enemy = get_parent().get_node("Enemies")

var married = false
var children = false

func monturn():
	menu.emit_signal("monsterscene")

func activate(sitem,previtem):
	menu.activeset(false)
	text.show()
	match previtem:
		"Mr. Poly":
			match sitem:
				"Check":
					text.type("* MR POLY ATK " + str(enemy.enemies["Mr. Poly"].DMG) + " DEF " + str(enemy.enemies["Mr. Poly"].DF) + "{}{p}* Born as an orphan node.")
					yield(text,"typefin")
					monturn()
				"Marry":
					if enemy.enemies["Mr. Poly"].docile == false:
						if married:
							text.type("* You get down on one knee and{}  propose.{/}{}{p}* Mr. Poly is confused.")
							yield(text,"typefin")
							monturn()
						else:
							text.type("* You get down on one knee and{}  propose.{/}{}{p}* Mr. Poly says yes!")
							yield(text,"typefin")
							text.type("* Mr. Poly wants something more,{}  though...")
							yield(text,"typefin")
							monturn()
							yield(menu,"buttons")
							married = true
					else:
						text.type("* Mr. poly doesn't notice you.")
						yield(text,"typefin")
						monturn()
				"Add node":
					if enemy.enemies["Mr. Poly"].docile == false:
						if married:
							text.type("* You had a miscarrage.{p} Whoops!")
							yield(text,"typefin")
							text.type("* Mr. poly burst out crying and{}  runs into a corner.")
							yield(text,"typefin")
							text.type("* Everthing starts looking{}  blue...")
							yield(text,"typefin")
							enemy.docile("Mr. Poly")
							monturn()
						else:
							text.type("* What?{p} You can't have children{}  before marrage!")
							yield(text,"typefin")
							monturn()
					else:
						text.type("* Mr. poly doesn't notice you.")
						yield(text,"typefin")
						monturn()
		"Real Soul":
			match sitem:
				"Check":
					text.type("* REAL SOUL ATK " + str(enemy.enemies["Real Soul"].DMG) + " DEF " + str(enemy.enemies["Real Soul"].DF) + "{p}{}* Currently free of legal{}  trouble at the moment.")
					yield(text,"typefin")
					monturn()
				"Call out":
					
					text.type("* You make an [color=red]EXPOSED[/color] video on{}  Real Soul.")
					yield(text,"typefin")
					text.type("* Real Soul makes a{}  corresponding apology video{}  right after.")
					yield(text,"typefin")
					enemy.docile("Real Soul")
					monturn()
