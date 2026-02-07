class_name Rose extends StaticBody2D

var ATTACKS = []
var pumpCurvePoints
var pump

var life = gameConfig.rose_life

const ROOT = preload("res://scenes/rose/root.tscn");

func _ready() -> void:
	gameConfig.rose = self

func _physics_process(_delta):
	for attack in ATTACKS:
		life -= attack.damage
	ATTACKS = []
	handleFelure()
	
func pumpBlood(targetPosition: Vector2, target: CharacterBody2D) -> void:
	var root = ROOT.instantiate()
	root.setCurvePoints(targetPosition.x - global_position.x, target)
	root.position = $rootSpawnerTarget.position
	self.add_child(root)

func take_damage(attack):
	if(attack.origin != "player"):
		ATTACKS.push_front(attack)

func handleFelure():
	if life > 80 :
		$AnimatedSprite2D.visible = false
	elif life <= 80 and life > 60 :
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.animation = "felure"
		$AnimatedSprite2D.frame = 0
	elif life <= 60 and life > 40 :
		$AnimatedSprite2D.frame = 1
	elif life <= 40 and life > 20 :
		$AnimatedSprite2D.frame = 2
	elif life <= 20 and life > 0 :
		$AnimatedSprite2D.frame = 3
	elif life <= 0 :
		$AnimatedSprite2D.visible = false
		$Rose.visible = false
		$DeadRose.visible = true
		$GPUParticles2D.emitting = true
