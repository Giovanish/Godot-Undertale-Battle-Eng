extends Area2D
class_name DmgBox

export(bool) var mask_outside
export(bool) var hide_when_hit
export(bool) var follow_defdmg = true
export(bool) var follow_definv = true

export(int) var damage
export(float) var inv_frames

export(int) var disappear_level = 1

export(String,"norm","still","move") var color = "norm"

export(Color) var white = Color("ffffff")
export(Color) var blue = Color("00fffb")
export(Color) var orange = Color("ffb500")
export(Color) var green = Color("00ff00")

export(int) var emy_index = 0

func _ready():
	add_to_group("dmgbox")

	$Collision.self_modulate.a = 0

func _process(delta):
	if mask_outside:
		get_parent().light_mask = 2
	else:
		get_parent().light_mask = 1
	if follow_defdmg == false:
		add_to_group("dmgbox(inv)")
	if follow_defdmg == false:
		add_to_group("dmgbox(dmg)")
	match color:
		"norm":
			get_parent().self_modulate = white
		"still":
			get_parent().self_modulate = blue
		"move":
			get_parent().self_modulate = orange
	monitorable = is_visible_in_tree()
	monitoring = is_visible_in_tree()

func disappear():
	match disappear_level:
		1:
			get_parent().queue_free()
		2:
			get_parent().get_parent().queue_free()
		3:
			get_parent().get_parent().get_parent().queue_free()
		4:
			get_parent().get_parent().get_parent().get_parent().queue_free()
		5:
			get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
		6:
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
		7:
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
		8:
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
		9:
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
		10:
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
