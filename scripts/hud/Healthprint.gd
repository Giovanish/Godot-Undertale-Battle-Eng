extends RichTextLabel

onready var hp = get_parent().get_parent().get_node("Health/HealthBG/HealthCover")
onready var hpbg = get_parent().get_parent().get_node("Health/HealthBG")

func _process(delta):
	bbcode_text = str(hp.value).pad_zeros(len(str(hpbg.max_value)))+" / "+str(hpbg.max_value)
