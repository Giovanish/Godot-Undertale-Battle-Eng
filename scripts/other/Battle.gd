extends Node2D

var pturn = false
var turn = 0
var box : String
var turntime : float

signal scene
signal monturnover

func _ready():
	$SoulFleeing.hide()

func play(boxtype):
	box = boxtype
	$Menu/Box/Boxanim.play(boxtype)

func flee():
	$Menu.activeset(false)
	$SoulFleeing/FleeSnd.play()
	$Menu/Box/Menutext.type("* I'm taking the kids.")
	$SoulFleeing/Anim.play("walk")
	$Tween.interpolate_property($SoulFleeing, "position",
		$SoulFleeing.position,
		Vector2(-332,$SoulFleeing.position.y),
		1.2,
		Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_property($Black, "modulate",
		Color(0,0,0,0),
		Color(0,0,0,1),
		2,
		Tween.TRANS_QUART,Tween.EASE_IN)
	$Tween.start()
	$Black.show()

func end_battle():
	var xp : int
	var g : int
	
	for enem in $Enemies.enemies_killed:
		xp += $Enemies.enemies[enem].EXP
	for enem in $Enemies.enemies:
		g += $Enemies.enemies[enem].GLD
	
	$Menu/Box/Menutext.type("* YOU WON!{p}{}* You earned "+str(xp)+" XP and "+str(g)+" G.")
	yield($Menu/Box/Menutext,"typefin")
	$Black.show()
	$Tween.interpolate_property($Black, "modulate",
		Color(0,0,0,0),
		Color(0,0,0,1),
		0.8,
		Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()

func game_over():
	get_tree().change_scene("res://gameover/Game Over.tscn")
	Gameover.soulpos = $Soul.position

func _on_Menu_monsterturn():
	$Soul.moving = true
	$Soul.falling = true
	
	yield(get_tree().create_timer(turntime),"timeout")
	
	$Menu/Box/Boxanim.play_backwards(box)
	
	$Soul.moving = false
	$Soul.falling = false
	$Soul.direction = Vector2.ZERO
	$Soul/Hitbox/Collision.set_deferred("disabled", true)
	
	emit_signal("monturnover")
	
	yield($Menu/Box/Boxanim,"animation_finished")
	
	$Soul/Hitbox/Collision.set_deferred("disabled", false)
	
	$Menu.emit_signal("buttons")
	$Menu.emit_signal("cdepth_change",$Menu.cdepth,$Menu/Buttons.focus,false)
	$Menu.activeset(true)
	$Menu/Buttons.get_child($Menu/Buttons.focus).frame = 1
	$Menu.cdepth = -1
	

func _on_Menu_monsterscene():
	$Menu.cdepth = -1
	$Soul.moving = false
	$Soul.falling = false
	
	pturn = false
	turn += 1
	
	$Menu.activeset(false)
	$Menu/Box/Menutext.type("")
	
	$Soul.visible = true
	$Soul.position = Vector2(3,68)
	yield($Menu/Box/Boxanim,"animation_finished")
	emit_signal("scene")
