extends Sprite

onready var tween = get_parent().get_node("Tween")
onready var deathlog = get_parent().get_parent()
onready var text = $Determination

signal retry

func _ready():
	modulate = Color(0,0,0,0)

func _on_soul_GameOverTitle():
	tween.interpolate_property(self,"modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(1.5),"timeout")
	text.type("Don't worry! You'll get back up!")
	yield(text, "typefin")
	text.type("Well, if you choose to, anyway.")
	yield(text, "typefin")
	text.type("Anyway, anyways, stay determined!")
	yield(text, "typefin")
	text.type("...I THINK THAT'S MY LINE.","papyrus")
	yield(text, "typefin")
	tween.interpolate_property(self,"modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")
	yield(get_tree().create_timer(1),"timeout")
	get_parent().retry()
