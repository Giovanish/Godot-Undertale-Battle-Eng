extends ItemList

const psize = 4
var page = 0
var pages
var sectsize : int

var coord = Vector2(1,1)
var itemposx := [-248,7]
var itemposy := [46,79,110]

onready var menu = get_parent().get_parent().get_parent()
onready var soul = get_parent().get_parent().get_parent().get_parent().get_node("Soul")

signal optmoved

func update_text():
	$Left.bbcode_text = get_item_text(0 + (page * 4)) + "[fill]" + get_item_text(2 + (page * 4))
	$Right.bbcode_text = get_item_text(1 + (page * 4)) + "[fill]" + get_item_text(3 + (page * 4))
	$Page.bbcode_text = "PAGE " + str(page + 1)

func update_list():
	clear()
	for item in Stats.inventory:
		add_item("* " + item)
		pages = range(0,get_item_count(),psize)[range(0,get_item_count(),psize).size() - 1] / 4

func update_sect():
	if page == pages and not pages == 0 and not get_item_count() % psize == 0:
		sectsize = get_item_count() % psize
	elif pages == 0:
		sectsize = get_item_count()
	elif get_item_count() % psize == 0:
		sectsize = 4
	else:
		sectsize = 4

func update():
	update_list()
	update_sect()
	update_text()

func _ready():
	update()

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
		if sectsize > 1:
			if sectsize > 2:
				if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
					if coord.x == 1:
						if coord.y == 2:
							coord.y = 1
						else:
							coord.y = 2
					if coord.x == 2:
						if sectsize == 4:
							if coord.y == 2:
								coord.y = 1
							else:
								coord.y = 2
						else:
							coord.y = 2
							coord.x = 1
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			if coord.x == 1:
				if sectsize > 1:
					coord.x = 2
					if coord.y == 2 and sectsize == 3 and page == 0:
						coord.y = 1
					elif sectsize == 3 and page > 0:
						if Input.is_action_just_pressed("right"):
							coord.y = 1
				if Input.is_action_just_pressed("left") and not page <= 0:
					page -= 1
					coord.x = 2
					update_text()
					update_sect()
			else:
				if sectsize > 1:
					coord.x = 1
				if Input.is_action_just_pressed("right") and not page == pages:
					page += 1
					update_text()
					update_sect()
					if sectsize <= 2:
						coord.y = 1
