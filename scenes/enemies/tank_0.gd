extends CharacterBody2D

var SPEED := 50

@export var health := 30
@export var direction := -1
@export var reloadingTime := 3

var state := 'walk'
var isShooting := false

const BULLET_GUN = preload("res://scenes/BulletGun/tank_0_bullet.tscn")

signal on_death
signal on_taking_shoot

func _ready() -> void:
	$Body.scale.x  = -direction * $Body.scale.x


func _physics_process(delta: float) -> void:
	if health <= 0:
		state = "dead"

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
	handlePositionShield()
	move_and_slide()
	
func handlePositionShield():
	var player = gameConfig.player;
	var shield = $Tank0Shield
	if !player: return
	var angle = ($Tank0Shield/center.global_position - player.position).angle()
	if angle < 0 :
		if angle < -2:  angle = PI
		else:  angle = 0
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
	var front = $Body/canon_origin

	if abs(front.global_position).x < 350:
		state = 'attack'

func take_damage(attack):
	health -= attack.damage
	on_taking_shoot.emit()
	modulateColorSprite(Color(1, 0, 0.1, 0.3))
	await get_tree().create_timer(0.05).timeout
	modulateColorSprite(Color.WHITE)
	
func modulateColorSprite(c:Color):
	$Body/Tank0Body.modulate = c
	$Tank0Shield.modulate =  c

func _on_animated_sprite_2d_animation_finished() -> void:
	on_death.emit(self.global_position, self)
	queue_free()
