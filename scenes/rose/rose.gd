class_name Rose extends StaticBody2D

signal on_update_life

const ROOT = preload("res://scenes/rose/root.tscn");
const MAX_LIFE := 100.0

var ATTACKS = []
var pumpCurvePoints
var pump
var life := MAX_LIFE


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
	healing(target.NAME)

func take_damage(attack):
	if(!attack.origin.begins_with('player')):
		ATTACKS.push_front(attack)
		

func healing(killName: String):
	if life == MAX_LIFE :
		return
	on_update_life.emit()
	if killName == 'crs':
		life += 0.1
	if killName == 'tank_0':
		life += 5
	if life > MAX_LIFE :
		life = MAX_LIFE

func handleFelure():
	on_update_life.emit()
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
