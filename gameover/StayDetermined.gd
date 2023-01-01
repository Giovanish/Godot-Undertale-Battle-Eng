extends RichTextLabel

var slow : bool
var prin : String
var skip : bool
var time : float

signal typefin
signal typeskip

func _input(event):
	if skip == true:
		skipp()
	if visible_characters == get_total_character_count():
		if Input.is_action_just_pressed("z"):
			emit_signal("typefin")

func type(dialog : String, person := "none", waittime := 0.03, skippable := true):
	$Timer.wait_time = waittime
	time = waittime
	skip = skippable
	visible_characters = 1
	match person:
		"none":
			set_bbcode(dialog)
		"sans":
			set_bbcode("[b]" + dialog + "[/b]")
		"papyrus":
			set_bbcode("[i]" + dialog + "[/i]")

func _on_Timer_timeout():
	if not visible_characters==get_total_character_count():
		visible_characters+=1
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
		else:
			$Timer.wait_time = time
	else:
		emit_signal("typeskip")

func skipp():
	if Input.is_action_just_pressed("x"):
		visible_characters = get_total_character_count()
