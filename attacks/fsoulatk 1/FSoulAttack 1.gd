extends Node2D

func shoot():
	var soul = $Soul.duplicate()
	add_child(soul)
	soul.position.y = get_tree().current_scene.get_node("Soul").position.y
	soul.get_node("Sprite/Animation").play("shoot")
	yield(soul.get_node("Sprite/Animation"),"animation_finished")
	soul.queue_free()

func _ready():
	for box in get_tree().get_nodes_in_group("dmgbox"):
		if box.emy_index == 1:
			box.damage = get_tree().current_scene.get_node("Enemies").enemies["Real Soul"].DMG
	shoot()

func _on_Timer_timeout():
	shoot()
