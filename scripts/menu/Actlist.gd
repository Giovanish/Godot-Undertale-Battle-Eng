extends ItemList

onready var menu = get_parent().get_parent().get_parent()
onready var soul = get_parent().get_parent().get_parent().get_parent().get_node("Soul")

signal optmoved

func update():
	if get_item_count() >= 1:
			$Left.bbcode_text = get_item_text(0)
	if get_item_count() >= 2:
			$Right.bbcode_text = get_item_text(1)
	if get_item_count() >= 3:
			$Left.bbcode_text = get_item_text(0) + "[fill]" + get_item_text(2)
	if get_item_count() >= 4:
			$Right.bbcode_text = get_item_text(1) + "[fill]" + get_item_text(3)
	if get_item_count() >= 5:
			$Left.bbcode_text = get_item_text(0) + "[fill]" + get_item_text(2) + "[fill]" + get_item_text(4)
	if get_item_count() >= 6:
			$Right.bbcode_text = get_item_text(1) + "[fill]" + get_item_text(3) + "[fill]" + get_item_text(5)
	

func _ready():
	for item in get_item_count():
		set_item_text(item, "* " + get_item_text(item))
	update()

var coord = Vector2(1,1)
var itemposx := [-248,7]
var itemposy := [46,79,110]

func optmove(posx,posy,pos = Vector2()):
	pos.y = coord.y + posy
	pos.x = coord.x + posx
	emit_signal("optmoved")
	return pos

func even(number : int):
	var even
	if number % 2 == 1:
		even = false
	if number % 2 == 0:
		even = true
	return even

func _process(delta):
	if menu.options == true:
		soul.position = Vector2(itemposx[coord.x-1],itemposy[coord.y-1])
		if get_item_count() > 1:
			if get_item_count() > 2:
				if Input.is_action_just_pressed("down"):
					if coord.x == 1:
						if not coord.y >= round(get_item_count() / 2.0) and not coord.y == 3:
							coord = optmove(0,1)
						else:
							coord.y = 1
					if coord.x == 2:
						if not get_item_count() == 5 and not get_item_count() == 3:
							if not coord.y >= round(get_item_count() / 2.0) and not coord.y == 3:
								coord = optmove(0,1)
							else:
								if even(get_item_count()) == false:
									coord = optmove(0,1)
									coord.x = 1
								else:
									coord.y = 1
						else:
							if not get_item_count() == 3:
								if not coord.y >= 2:
									coord = optmove(0,1)
								else:
									if even(get_item_count()) == false:
										coord = optmove(0,1)
										coord.x = 1
									else:
										coord.y = 1
							else:
								if even(get_item_count()) == false:
									coord = optmove(0,1)
									coord.x = 1
								else:
									coord.y = 1
				if Input.is_action_just_pressed("up"):
					if coord.x == 1:
						if coord.y <= 1:
							coord.y = round(get_item_count() / 2.0)
						else:
							coord = optmove(0,-1)
					if coord.x == 2:
						if not get_item_count() == 5 and not get_item_count() == 3:
							if coord.y <= 1:
								coord.y = round(get_item_count() / 2.0)
							else:
								coord = optmove(0,-1)
						else:
							if not get_item_count() == 3:
								if not coord.y <= 1:
									coord.y = 2
								else:
									coord.y = 1
							if get_item_count() == 5:
								if not coord.y <= 1:
									coord.y = 1
								else:
									coord.y = 2
			if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
				if coord.x == 1:
					coord.x = 2
					if coord.y == round(get_item_count() / 2.0) and even(get_item_count()) == false:
						coord.y -= 1
				else:
					coord.x = 1
