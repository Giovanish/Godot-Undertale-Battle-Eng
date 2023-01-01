extends Node2D

var skipgameover

func _ready():
	skipgameover = false
	yield(get_tree().create_timer(1),"timeout")
	skipgameover = true

func retry():
	get_tree().change_scene("res://Scenes/Battle.tscn")
	Stats.health = 20

func _process(delta):
	if skipgameover == true:
		if Input.is_action_just_pressed("c"):
			retry()
