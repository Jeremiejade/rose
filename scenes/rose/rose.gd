extends StaticBody2D

var ATTACKS = []
var ATTACK_IDS = []
@export var life: int = 100

func _physics_process(_delta):
	for attack in ATTACKS:
		ATTACK_IDS = ATTACK_IDS.filter(func(id): return id != attack.id)
		life -= attack.damage
	ATTACKS = []
	handleFelure()

func addAttack(attack):
	var alreadyAttacking = ATTACK_IDS.find(attack.id)

	if alreadyAttacking == -1:
		ATTACK_IDS.push_front(attack.id)
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
