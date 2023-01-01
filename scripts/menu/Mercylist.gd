extends ItemList

var coord = Vector2(1,1)
var itemposx := [-248,7]
var itemposy := [46,79,110]

onready var menu = get_parent().get_parent().get_parent()
onready var root = menu.get_parent()
onready var enemy = root.get_node("Enemies")
onready var soul = get_parent().get_parent().get_parent().get_parent().get_node("Soul")

signal spared
signal optmoved

func update():
	if enemy.get_dociles().size() > 0:
		set_item_text(0,"[color=" + Global.bristrcolor + "]* Spare[/color]")
		for monlist in get_tree().get_nodes_in_group("monlist"):
			for mon in enemy.get_dociles():
				monlist.bright_item(mon)
	else:
		set_item_text(0,"* Spare")
	match get_item_count():
		1:
			$Left.bbcode_text = get_item_text(0)
		2:
			$Left.bbcode_text = get_item_text(0) + "[fill]" + get_item_text(1)
		3:
			$Left.bbcode_text = get_item_text(0) + "[fill]" + get_item_text(1) + "[fill]" + get_item_text(2)
	if get_item_count() > 3:
		match get_item_count():
			4:
				$Right.bbcode_text = get_item_text(3)
			5:
				$Right.bbcode_text = get_item_text(3) + "[fill]" + get_item_text(4) 
			6:
				$Right.bbcode_text = get_item_text(3) + "[fill]" + get_item_text(4) + "[fill]" + get_item_text(5)
	else:
		$Right.bbcode_text = ""

func spareall():
	if enemy.enemies_alive.size() == 0:
		get_tree().quit()
	else:
		emit_signal("spared")

func _ready():
	update()
	for item in get_item_count():
		set_item_text(item, "* " + get_item_text(item))

func optmove(posx,posy,pos = Vector2()):
	pos.y = coord.y + posy
	pos.x = coord.x + posx
	emit_signal("optmoved")
	return pos

func _on_Menu_buttons():
	update()

func _process(delta):
	if menu.options == true:
		soul.position = Vector2(itemposx[coord.x-1],itemposy[coord.y-1])
		if get_item_count() > 1:
			if Input.is_action_just_pressed("down"):
				if coord.x == 1:
					if coord.y >= 3 or coord.y == get_item_count():
						coord.y = 1
					else:
						coord = optmove(0,1)
				if coord.x == 2:
					if coord.y == get_item_count() - 3:
						if get_item_count() != 6:
							coord.x = 1
							coord = optmove(0,1)
						else:
							coord.y = 1
					else:
						coord = optmove(0,1)
			if Input.is_action_just_pressed("up"):
				if coord.x == 1:
					if coord.y <= 1:
						if get_item_count() < 3:
							coord.y = get_item_count()
						else:
							coord.y = 3
					else:
						coord = optmove(0,-1)
				if coord.x == 2:
					if coord.y <= 1:
						coord.y = get_item_count() - 3
					else:
						coord = optmove(0,-1)
			if get_item_count() > 3:
				if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
					if coord.x == 1:
						coord.x = 2
						if coord.y + 3 > get_item_count():
							coord.y = get_item_count() - 3
					else:
						coord.x = 1
