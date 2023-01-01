extends Sprite

var soulpos : Vector2
onready var shards = get_node("Shards")

signal GameOverTitle

onready var soul = preload("res://Scenes/Battle.tscn").instance().get_node("Soul")

func _ready():
	position = Vector2(Gameover.soulpos.x + 320 ,Gameover.soulpos.y + 240)
	shards.show()
	shards.speed_scale = 0
	soulbreak()

func soulbreak():
	texture = load("res://sprites/SOUL/Other/UT Soul.png")
	yield(get_tree().create_timer(1),"timeout")
	$ShatterSnd.play()
	texture = load("res://sprites/SOUL/Other/SOUL Break.png")
	yield(get_tree().create_timer(1.5),"timeout")
	self_modulate.a = 0
	shards.speed_scale = 1
	yield(get_tree().create_timer(1.5),"timeout")
	shards.emitting = false
	emit_signal("GameOverTitle")
