extends Node2D

signal finished(missed)

func _ready():
	$Bar.position = Vector2(-20,65)
	$Anim.play("barslide")

var atk_multiplier

func _process(delta):
	for box in $Bar/BarBox.get_overlapping_areas():
		if box.is_in_group("atkbox"):
			atk_multiplier = $Bar/BarBox.get_overlapping_areas().size()
		if box.is_in_group("miss"):
			atk_multiplier = -1
			emit_signal("finished")
			set_process(false)
	if Input.is_action_just_pressed("z"):
		emit_signal("finished")
		$Anim.play("flicker")
		set_process(false)
