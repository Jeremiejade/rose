extends CharacterBody2D

var SPEED := 50

@export var health := 10
@export var direction := -1
@export var reloadingTime := 3

var state := 'walk'
var isShooting := false

const BULLET_GUN = preload("res://scenes/BulletGun/tank_0_bullet.tscn")

func _ready() -> void:
	$Body.scale.x  = -direction * $Body.scale.x


func _physics_process(delta: float) -> void:
	if state != "dead" :
		if not is_on_floor():
			velocity += get_gravity() * delta
		if state == 'walk':
			velocity.x = direction * SPEED
		else :
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if state == 'attack' and !isShooting:
			attack()
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
	
func attack():
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

	if abs(front.global_position).x < 250:
		state = 'attack'
