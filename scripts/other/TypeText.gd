extends RichTextLabel

const pause = "{p}"

var skip : bool
var time := 0.03
var pausing : bool
var txt = bbcode_text

signal typefin
signal typeskip

func _input(event):
	if visible_characters == text.length():
		if Input.is_action_just_pressed("z"):
			emit_signal("typefin")
	if visible_characters < text.length():
		if skip == true:
			if Input.is_action_just_pressed("x"):
				skip()

var talking := false

func btype(dialog : String, waittime := 0.027, skippable := true, person := "none", auto_pausing := false):
	talking = true
	txt = "[tornado radius=1.3 freq=7]" + dialog + "[/tornado]"
	txt = txt.replace(pause,"[hide]" + pause + "[/hide]")
	txt = txt.replace("{}","[fill]")
	txt = txt.replace("{/}","[/fill]")
	set_deferred("bbcode_text", txt)
	$Timer.wait_time = time
	$Timer.start()
	pausing = auto_pausing
	time = waittime
	skip = skippable
	if auto_pausing == true:
		if not txt.rfind("* ...",5):
			visible_characters = 2
		else:
			visible_characters = 1
	else:
		visible_characters = 2
	match person:
		"sans":
			txt = "[b]" + txt + "[/b]"
		"papyrus":
			txt = "[i]" + txt + "[/i]"

func type(dialog : String, waittime := 0.027, skippable := true, person := "none", auto_pausing := false):
	txt = dialog
	txt = txt.replace(pause,"[hide]" + pause + "[/hide]")
	txt = txt.replace("{}","[fill]")
	txt = txt.replace("{/}","[/fill]")
	set_deferred("bbcode_text", txt)
	$Timer.wait_time = time
	$Timer.start()
	pausing = auto_pausing
	time = waittime
	skip = skippable
	if auto_pausing == true:
		if not txt.rfind("* ...",5):
			visible_characters = 2
		else:
			visible_characters = 1
	else:
		visible_characters = 2
	match person:
		"sans":
			txt = "[b]" + txt + "[/b]"
		"papyrus":
			txt = "[i]" + txt + "[/i]"

func _on_Timer_timeout():
	
	if not visible_characters==text.length() and not txt == "":
		if has_node("TypeSnd"):
			if is_visible_in_tree() and modulate.a > 0:
				$TypeSnd.play()
			else:
				$TypeSnd.stop()
		visible_characters+=1
		if pausing == false:
			if visible_characters + 1 == text.rfind(pause,visible_characters + 1):
				$Timer.wait_time = 0.5
			else:
				$Timer.wait_time = time
		else:
			if visible_characters == text.rfind(",",visible_characters):
				$Timer.wait_time = 0.5
			elif visible_characters == text.rfind(".",visible_characters):
				if not visible_characters + 1 == text.rfind(".",visible_characters + 1):
					if not visible_characters + 1 == text.rfind("...",visible_characters + 1):
						if visible_characters + 1 == text.rfind(" ",visible_characters + 1):
							$Timer.wait_time = 0.5
			elif visible_characters == text.rfind("!",visible_characters):
				if not visible_characters + 1 == text.rfind("!",visible_characters + 1):
					$Timer.wait_time = 0.5
			elif visible_characters == text.rfind(":",visible_characters):
				$Timer.wait_time = 0.5
			elif visible_characters == text.rfind(";",visible_characters):
				$Timer.wait_time = 0.5
			elif visible_characters == text.rfind("*",visible_characters):
				yield($Timer, "timeout")
				if not visible_characters == text.rfind(".",visible_characters)+2:
					visible_characters+=2
			else:
				$Timer.wait_time = time
	else:
		emit_signal("typeskip")
		if has_node("TypeSnd"):
				$TypeSnd.stop()

func clear():
	set_bbcode("")
	set_visible_characters(0)

func skip():
	visible_characters = text.length()
	emit_signal("typeskip")
