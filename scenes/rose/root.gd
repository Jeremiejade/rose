extends Node2D

var vectors: PackedVector2Array
var meat: CharacterBody2D
var isEating: bool
var step = 2

func _process(_delta: float) -> void:
	if(!vectors):
		pass
	if (isEating):
		pass
	if(step == len(vectors)):
		eat()
	
	grow()

func setCurvePoints(positionTargetX, target):
	meat = target
	var curve = Curve2D.new()
	var p0_in = Vector2.ZERO
	var p0_vertex = Vector2.ZERO
	var p0_out = Vector2(0, 100)
	var p1_in = Vector2(target.direction * 100, 100)
	var p1_vertex = Vector2(positionTargetX * 2, 0)
	var p1_out = Vector2.ZERO
	
	curve.add_point(p0_vertex, p0_in, p0_out)
	curve.add_point(p1_vertex, p1_in, p1_out)
	
	vectors = curve.tessellate()

func eat():
	isEating = true
	$AnimationPlayer.play("eating")

func unGrow():
	meat.eat()
	queue_free()

func grow():
	$Line2D.points = vectors.slice(0, step)
	step += 1
