extends CharacterBody2D

var SPEED := 50
const SHIELD_SPEED := PI/150
const NAME = 'tank_0'

@export var health := 30
@export var shieldHealth := 150
@export var direction := -1
@export var reloadingTime := 3

var state := 'walk'
var isShooting := false

const BULLET_GUN = preload("res://scenes/BulletGun/tank_0_bullet.tscn")

signal on_death
signal on_taking_shoot

func _ready() -> void:
	$Body.scale.x  = -direction * $Body.scale.x
	if(direction > 0):
		$Tank0Shield.rotation = PI


func _physics_process(delta: float) -> void:
	if health <= 0:
		state = "dead"
	elif shieldHealth == 0:
		shieldHealth -= 1

	if state != "dead" :
		if not is_on_floor():
			velocity += get_gravity() * delta
		if state == 'walk':
			velocity.x = direction * SPEED
		else :
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if state == 'attack' and !isShooting:
			shoot()
	handleAnimation()
	canAttack()
	if shieldHealth > 0:
		handlePositionShield()
	move_and_slide()
	
func handlePositionShield():
	var player = gameConfig.player;
	var shield = $Tank0Shield
	if !player: return
	var angle = ($Tank0Shield/center.global_position - player.position).angle()
	
	if angle < 0 :
		if angle < -PI/2:  angle = PI
		else:  angle = 0
	
	var angleRange = angle - shield.rotation
	if abs(angleRange) > SHIELD_SPEED :
		angle = shield.rotation + (SHIELD_SPEED * angleRange/abs(angleRange))
	
	shield.rotation = angle
	
func handleAnimation():
	if state == 'dead':
		$AnimatedSprite2D.play("boom")
		$AnimatedSprite2D.visible = true
	
func shoot():
	isShooting = true
	var bullet_instance = BULLET_GUN.instantiate()

	get_tree().root.add_child(bullet_instance)
	bullet_instance.position = $Body/canon_origin.global_position
	bullet_instance.direction = direction
	await get_tree().create_timer(reloadingTime).timeout
	isShooting = false
	pass

func canAttack() -> void:
	var frontGlobalePosition = $Body/canon_origin.global_position
	
	var roseGLobalePosition = gameConfig.rose.global_position
	var playerGloablePosition = gameConfig.player.global_position

	if abs(frontGlobalePosition - roseGLobalePosition).x < 350 ||  abs(frontGlobalePosition - playerGloablePosition).x < 350:
		state = 'attack'
	elif state == 'attack' :
		state = 'walk'
	
func take_damage(attack):
	if attack.hurt_box_name == "Shield":
		shieldHealth -= attack.damage
		modulateColorSprite(Color(1, 0, 0.1, 0.3), 'shield')
		await get_tree().create_timer(0.05).timeout
		modulateColorSprite(Color.WHITE, 'shield')
		if shieldHealth <= 0:
			$Tank0Shield.queue_free()
			$CollisionShape2D2.queue_free()
	else :
		health -= attack.damage
		on_taking_shoot.emit()
		var target = 'all'
		if(shieldHealth <= 0):
			target = 'tank'
		modulateColorSprite(Color(1, 0, 0.1, 0.3), target)
		await get_tree().create_timer(0.05).timeout
		modulateColorSprite(Color.WHITE, target)
	
func modulateColorSprite(c:Color, target = 'all'):
	if target == 'all' :
		$Body/Tank0Body.modulate = c
		$Tank0Shield.modulate =  c
	if target == 'tank' :
		$Body/Tank0Body.modulate =  c
	if target == 'shield' :
		$Tank0Shield.modulate =  c
		
func _on_animated_sprite_2d_animation_finished() -> void:
	on_death.emit(self.global_position, self)
	queue_free()
