extends ProgressBar
class_name MonHealthBar

signal finished

onready var enemy = get_parent().get_parent().get_parent()
export(String) var hp_hint

func _ready():
	hide()
	value = enemy.enemies[hp_hint].HP

func bounce():
	show()
	var atkscr = get_parent().get_parent().get_parent().get_parent().get_node("AttackScreen")
	add_to_group("monhpbar")
	atkscr.output_dmg -= enemy.enemies[hp_hint].DF
	if atkscr.output_dmg <= 0:
		$DamageText.set("custom_colors/default_color", Color("c1c1c1"))
		$DamageText.bbcode_text = "[center]MISS"
		self_modulate.a = 0
	else:
		enemy.enemies[hp_hint].HP -= atkscr.output_dmg
		$DamageText.set("custom_colors/default_color", Color("ff0000"))
		$DamageText.bbcode_text = "[center]" + str(atkscr.output_dmg)
		get_parent().get_parent().get_node("Anim").play("hit")
		get_parent().get_parent().get_parent().get_node("Sounds/MonHit").play()
	$Tween.interpolate_property(self, "value",
		value,
		enemy.enemies[hp_hint].HP,
		1.8,
		Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property($DamageText, "rect_position",
		$DamageText.rect_position,
		Vector2($DamageText.rect_position.x, $DamageText.rect_position.y - 25),
		0.35,
		Tween.TRANS_QUART,Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.35),"timeout")
	$Tween.interpolate_property($DamageText, "rect_position",
		$DamageText.rect_position,
		Vector2($DamageText.rect_position.x, $DamageText.rect_position.y + 36),
		0.8,
		Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	$DamageText.rect_position.y -= 11
	self_modulate.a = 1
	emit_signal("finished")
