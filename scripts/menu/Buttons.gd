extends Control

var focus := 0

onready var menu = get_parent()
onready var text = get_parent().get_node("Box/Menutext")
onready var soul = get_parent().get_parent().get_node("Soul")
onready var sound = get_parent().get_node("Sounds")

signal pressed(focus)

func root():
	return get_tree().get_nodes_in_group("root")[0]

func set_focus(foc : int):
	if not foc > 3 and not foc < 0:
		focus = foc
	if foc > 3:
		focus = 0
	if foc < 0:
		focus = 3
	soul.position = soul.buttonpos[focus]
	get_child(focus).frame = 1
	for button in get_children():
		if not button == get_child(focus):
			if button == menu.snd("FocusSnd"):
				continue
			button.frame = 0

func _process(delta):
	if root().pturn == true:
		if menu.options == false:
			if Input.is_action_just_pressed("right"):
				set_focus(focus + 1)
				menu.snd("FocusSnd").play()
			if Input.is_action_just_pressed("left"):
				set_focus(focus - 1)
				menu.snd("FocusSnd").play()
			if Input.is_action_just_pressed("z") and menu.cdepth == -1:
				emit_signal("pressed", focus)
			elif menu.cdepth == -2:
				menu.cdepth = -1
		if menu.active == false:
			for button in get_children():
				button.frame = 0


func _on_Menu_buttons():
	get_child(focus).frame = 1
	menu.options = false
	root().pturn = true
	for att in get_tree().get_nodes_in_group("attack"):
		att.hide()
	set_focus(focus)
	match root().turn:
		0:
			text.type("* You stumble upon a[tornado radius=3 freq=3][color=aqua] Godot[fill]  Undertale[/fill][/color][/tornado] battle engine.",0.04)
		1:
			if menu.getsel() == "Bisicle":
				text.type("* You crash landed into a tree.")
			else:
				text.type("* This is filler.")
		_:
			 text.type("* This is filler.")
