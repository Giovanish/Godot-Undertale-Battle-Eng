extends Node

var OWitems := ["Butterscotch Pie", "Urchin", "Spoke", "Bisicle", "Cherries", "Turkey Leg", "Turkey Dinner"]
var inventory := []
var pname = "Gio"

var plevel = 1
var health = 20
var maxhealth = 20 + ((plevel - 1)* 4)

#var basedef = round(plevel - 1 / 2) didn't fell like adding a def system in a simple engine, so I left these here for you
#var def 

var weapon = "Toy Knife"
var baseatk = 3 + plevel + 1
var atk = 3

const transitems = {
	"Butterscotch Pie": "Pie",
	"Turkey Dinner": "T. Dinner",
	"Turkey Leg" : "T. Leg",
	}

func _ready():
	translate_items()

func translate_items(overw = false):
	if not overw:
		inventory.clear()
		for item in OWitems:
			if item in transitems.keys():
				item = transitems.get(item)
			inventory += [item]
	else:
		OWitems.clear()
		for item in inventory:
			if item in transitems.values():
				item = transitems.keys()[transitems.values().find(item)]
			OWitems += [item]

func root():
	return get_tree().get_nodes_in_group("root")[0]
