extends Node

const defres = Vector2(640,480)
var customres = Vector2(960,720)

var fullscreen = true

var diffres := true

func _ready():
	if diffres:
		change_res(customres)
	else:
		change_res(defres)

func _process(delta):
	if Input.is_action_just_pressed("space") and Input.is_action_pressed("alt"):
		diffres = not diffres
		if diffres:
			change_res(customres)
		else:
			change_res(defres)
	if fullscreen == true:
		if Input.is_action_just_pressed("f4"):
			OS.window_fullscreen = not OS.window_fullscreen

func root():
	return get_tree().get_nodes_in_group("root")[0]

func change_res(res):
	OS.window_size = res
	OS.center_window()
