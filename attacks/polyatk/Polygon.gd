extends Polygon2D

var polypos = [-48,20,88]
var speed = 1

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	position.y = -28
	position.x = polypos[rng.randi_range(0,2)]

func _process(delta):
	position.y += speed
