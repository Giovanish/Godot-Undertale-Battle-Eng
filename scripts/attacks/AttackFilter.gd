extends Node2D

onready var rect = $FilterRect
onready var box = get_parent().get_node("Menu/Box")

func _process(delta):
	rect.margin_bottom = box.margin_bottom
	rect.margin_left = box.margin_left
	rect.margin_top = box.margin_top
	rect.margin_right = box.margin_right
