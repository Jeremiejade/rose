extends StaticBody2D

var CRS_ATTACKS = []
var CRS_ATTACK_IDS = []
@export var life: int = 100

func _physics_process(_delta):
	for attack in CRS_ATTACKS:
		CRS_ATTACK_IDS = CRS_ATTACK_IDS.filter(func(id): return id != attack.id)
		life -= attack.damage
	CRS_ATTACKS = []
	handleFelure()

func addCRSAttack(attack):
	var alreadyAttacking = CRS_ATTACK_IDS.find(attack.id)

	if alreadyAttacking == -1:
		CRS_ATTACK_IDS.push_front(attack.id)
		CRS_ATTACKS.push_front(attack)

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
