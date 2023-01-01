extends ProgressBar

onready var fg = $HealthCover
onready var soul = get_parent().get_parent().get_parent().get_node("Soul")
onready var hitbox = soul.get_node("Hitbox")

var take_dmg = true

func _ready():
	max_value = Stats.maxhealth
	fg.value = Stats.health
	fg.page = fg.max_value - max_value
	rect_size.x = rect_min_size.x
	rect_min_size.x = max_value + (max_value / 4)

func _process(delta):
	if fg.value <= 0:
		Funcs.root().game_over()
	max_value = 20 + ((Stats.plevel - 1)* 4)
	Stats.health = fg.value
	Stats.maxhealth = max_value
	value = max_value
	if hitbox.get_overlapping_areas().size() > 0:
		for dmgbox in hitbox.get_overlapping_areas():
			if dmgbox is DmgBox:
				if take_dmg:
					if dmgbox.hide_when_hit:
						dmgbox.disappear()
					match dmgbox.color:
						"norm":
							fg.value -= dmgbox.damage
							soul.hit(dmgbox.inv_frames)
						"still":
							if soul.direction.x + soul.direction.y != 0:
								fg.value -= dmgbox.damage
								soul.hit(dmgbox.inv_frames)
						"move":
							if soul.direction.x + soul.direction.y == 0:
								fg.value -= dmgbox.damage
								soul.hit(dmgbox.inv_frames)

func _on_HealthCover_value_changed(value):
	if hitbox.get_overlapping_areas().size() > 0:
		if take_dmg:
			take_dmg = false
			yield(get_tree().create_timer(hitbox.get_overlapping_areas()[0].inv_frames),"timeout")
			take_dmg = true
