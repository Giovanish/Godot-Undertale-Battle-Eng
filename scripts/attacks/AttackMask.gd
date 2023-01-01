extends Light2D


func _process(delta):
	scale = Vector2(get_parent().rect_size.x - 10,get_parent().rect_size.y - 10)
