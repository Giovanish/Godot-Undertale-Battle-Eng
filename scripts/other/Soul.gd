extends KinematicBody2D

var buttonpos = [Vector2(-271,214), Vector2(-117,214), Vector2(41,214), Vector2(196,214)]
var texture = [load("res://sprites/soul/Red.png"), load("res://sprites/soul/Blue.png")]

export(String,"red","blue") var color = "red"
var direction = Vector2.ZERO
var speed = 150

var moving = false
var falling = false
var alreadyb = false

var jumpstr = 220.0
var gravity = 375.0
export(int,1,4) var gravdir = 1

func hit(frames):
	$HitSnd.play()
	if frames > 0.25:
		get_parent().get_node("Camera/Anim").play("shake")
		$Anim.play("hit")
		$Tween.interpolate_property($Anim, "playback_speed",
			1, 4.5,
			frames,
			Tween.TRANS_QUAD,Tween.EASE_OUT)
		$Tween.start()
	else:
		$Sprite.frame = 1
	yield(get_tree().create_timer(frames),"timeout")
	$Sprite.frame = 0
	$Anim.stop()

func _draw():
	VisualServer.canvas_item_set_clip($Sprite.get_canvas_item(),true)

func _physics_process(delta):
	$Sprite.texture = texture[1]
	match color:
		"red":
			$Sprite.texture = texture[0]
			rotation_degrees = 0
			if moving == true:
				direction.x = Input.get_action_strength("right") + Input.get_action_strength("left") * -1
				direction.y = Input.get_action_strength("down") + Input.get_action_strength("up") * -1
			if Input.is_action_pressed("x"):
				direction = move_and_slide(direction * speed / 2)
			else:
				direction = move_and_slide(direction * speed)
		"blue":
			$Sprite.texture = texture[1]
			if get_parent().pturn == false:
				match gravdir:
					1:
						rotation_degrees = 0
						if falling == true and not is_on_floor():
							direction.y += gravity * get_process_delta_time()
						direction = move_and_slide(direction, Vector2.UP)
						if moving == true:
							if Input.is_action_pressed("x"):
								direction.x = (Input.get_action_strength("right") + Input.get_action_strength("left") * -1) * speed / 2
							else:
								direction.x = (Input.get_action_strength("right") + Input.get_action_strength("left") * -1) * speed
							if Input.is_action_pressed("up") and is_on_floor():
								direction.y -= jumpstr
							elif Input.is_action_just_released("up") and direction.y < 0.0 and not is_on_floor() or is_on_ceiling() and alreadyb==false:
								direction.y = 0
								alreadyb = true
								falling = false
								yield(get_tree().create_timer(0.15),"timeout")
								falling = true
								alreadyb = false
					2:
						if get_parent().pturn == false:
							rotation_degrees = 270
						if falling == true and not is_on_floor():
							direction.x += gravity * get_process_delta_time()
						direction = move_and_slide(direction, Vector2.LEFT)
						if moving == true:
							if Input.is_action_pressed("x"):
								direction.y = (Input.get_action_strength("down") + Input.get_action_strength("up") * -1) * speed / 2
							else:
								direction.y = (Input.get_action_strength("down") + Input.get_action_strength("up") * -1) * speed
							if Input.is_action_pressed("left") and is_on_floor():
								direction.x -= jumpstr
							elif Input.is_action_just_released("left") and direction.x < 0.0 and not is_on_floor() or is_on_ceiling() and alreadyb==false:
								direction.x = 0
								alreadyb = true
								falling = false
								yield(get_tree().create_timer(0.15),"timeout")
								falling = true
								alreadyb = false
					3:
						if get_parent().pturn == false:
							rotation_degrees = 180
						if Input.is_action_pressed("x"):
							direction.x = (Input.get_action_strength("right") + Input.get_action_strength("left") * -1) * speed / 2
						else:
							direction.x = (Input.get_action_strength("right") + Input.get_action_strength("left") * -1) * speed
						if falling == true and not is_on_floor():
							direction.y -= gravity * get_process_delta_time()
						direction = move_and_slide(direction, Vector2.DOWN)
						if Input.is_action_pressed("down") and is_on_floor():
							direction.y += jumpstr
						elif Input.is_action_just_released("down") and direction.y > 0.0 and not is_on_floor() or is_on_ceiling() and alreadyb==false:
							direction.y = 0
							alreadyb = true
							falling = false
							yield(get_tree().create_timer(0.15),"timeout")
							falling = true
							alreadyb = false
					4:
						if get_parent().pturn == false:
							rotation_degrees = 90
						direction.y = (Input.get_action_strength("down") + Input.get_action_strength("up") * -1) * speed
						if falling == true and not is_on_floor():
							direction.x -= gravity * get_process_delta_time()
						direction = move_and_slide(direction, Vector2.RIGHT)
						if Input.is_action_pressed("right") and is_on_floor():
							direction.x += jumpstr
						elif Input.is_action_just_released("right") and direction.x > 0.0 and not is_on_floor() or is_on_ceiling() and alreadyb==false:
							direction.x = 0
							alreadyb = true
							falling = false
							yield(get_tree().create_timer(0.15),"timeout")
							falling = true
							alreadyb = false
			else:
				rotation_degrees = 0
				direction = Vector2.ZERO
