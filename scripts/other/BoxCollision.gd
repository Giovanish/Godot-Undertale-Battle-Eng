extends StaticBody2D

onready var box := get_parent().get_node("Box")

func _process(delta):
	position = Vector2(box.rect_position.x,box.rect_position.y)
	rotation_degrees = box.rect_rotation
	$Left.global_position = Vector2(box.margin_left + 322.5, global_position.y)
	$Top.global_position = Vector2(500, box.margin_top + 242)
	$Right.global_position = Vector2(box.margin_right + 318 , global_position.y)
	$Bottom.global_position = Vector2(500, box.margin_bottom + 237.5)
