extends ItemList

var coord = Vector2(1,1)
var itemposx := [-248,7]
var itemposy := [46,79,110]

onready var menu = get_parent().get_parent().get_parent()
onready var root = menu.get_parent()
onready var enemy = root.get_node("Enemies")
onready var soul = get_parent().get_parent().get_parent().get_parent().get_node("Soul")

signal optmoved

func bright_item(item):
	for itemb in get_item_count():
		if get_item_text(itemb) == "* " + item:
			var itemname = get_item_text(itemb)
			set_item_text(itemb,"[color=" + Global.bristrcolor + "]" + get_item_text(itemb) + "[/color]")
			update_text()

func update_text():
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

func update():
	match get_item_count():
		1:
			$Left/HealthBar1.show()
		2:
			$Left/HealthBar1.show()
			$Left/HealthBar2.show()
		3:
			$Left/HealthBar1.show()
			$Left/HealthBar2.show()
			$Left/HealthBar3.show()
	update_list()
	update_text()

func update_list():
	clear()
	for item in enemy.enemies_alive:
		add_item("* " + item)

func update_bars():
	for bar in enemy.enemies_alive.size() + 1:
		if $Left.get_child(bar) is ProgressBar:
			$Left.get_child(bar).show()
			$Left.get_child(bar).value = enemy.enemies[enemy.enemies_alive[bar - 1]]["HP"]
			$Left.get_child(bar).max_value = enemy.enemies[enemy.enemies_alive[bar - 1]]["MAX_HP"]
	for bar in $Left.get_child_count() - (enemy.enemies_alive.size() + 1):
		$Left.get_child(bar + enemy.enemies_alive.size() + 1).hide()

func _ready():
	update()
	for bar in enemy.enemies_alive.size() + 1:
		if $Left.get_child(bar) is ProgressBar:
			$Left.get_child(bar).show()

func optmove(posx,posy,pos = Vector2()):
	pos.y = coord.y + posy
	pos.x = coord.x + posx
	emit_signal("optmoved")
	return pos

func _process(delta):
	update_bars()
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
