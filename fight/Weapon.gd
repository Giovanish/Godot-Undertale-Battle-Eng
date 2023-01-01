extends Node2D

func _ready():
	$Sprite.frame = 0
	$Anim.play("attack")
	if visible:
		$AtkSnd.play()
