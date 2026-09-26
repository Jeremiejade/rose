extends CharacterBody2D

@export var health := 60
@export var direction := 1
@export var verticalAmplitude = 300
@export var limiteToDespawn: float

const NAME = 'copter'
const SPEED = 200.0

const STATES = {
	'fly':'fly',
	'attack': 'attack',
	'explode': 'explode',
	'dead': 'dead',
}

var state := STATES.fly
var verticalDirection := 1
var initialPosition: Vector2

var attackIsLaunched := false
var reloadingTime := 3
var roseGLobalePosition: Vector2

signal on_despawn
signal on_death

const BULLET_GUN = preload("res://scenes/BulletGun/copter_bullet.tscn")


func _ready() -> void:
	$AnimationPlayer.play("rotate_back")
	roseGLobalePosition = gameConfig.rose.global_position
	initialPosition = position
	if direction == 1:
		$copter.scale.x = -1
		$CollisionShape2D.position.x = -$CollisionShape2D.position.x
		$CollisionShape2D3.position.x = -$CollisionShape2D3.position.x
		$CollisionShape2D2.scale.x = -1
		$CollisionShape2D2.rotation = -$CollisionShape2D2.rotation
		$CollisionShape2D2.position.x = -$CollisionShape2D2.position.x

		$ZHurtBox/CollisionShape2D.position.x = -$ZHurtBox/CollisionShape2D.position.x
		$ZHurtBox/CollisionShape2D3.position.x = -$ZHurtBox/CollisionShape2D3.position.x
		$ZHurtBox/CollisionShape2D2.scale.x = -1
		$ZHurtBox/CollisionShape2D2.rotation = -$ZHurtBox/CollisionShape2D2.rotation
		$ZHurtBox/CollisionShape2D2.position.x = -$ZHurtBox/CollisionShape2D2.position.x

func _physics_process(delta: float) -> void:
	if health <= 0:
		state = STATES.dead
	if state == STATES.fly:
		velocity.x = direction * SPEED
		velocity.y = verticalDirection * SPEED/2
		manageVerticalDirection()
		
	if state == STATES.attack:
		velocity.x =  move_toward(velocity.x, 0, SPEED * delta)
		velocity.y =  move_toward(velocity.y, 0, SPEED * delta)
		if !attackIsLaunched:
			launchAttack()
	if state == STATES.dead:
		if is_on_floor():
			state = STATES.explode
		velocity.x += direction * SPEED/2 * delta
		velocity.y += SPEED * 3 * delta

		if abs(rotation) < PI/4:
			rotation += PI/4 * delta * direction
	if state == STATES.explode:
		velocity = Vector2(0, 0)
	manageAttack()
	handleAnimation()
	move_and_slide()
	manageDespawn()
	
func handleAnimation():
	if state == STATES.explode:
		$ExplosionAnimation.visible = true
		$ExplosionAnimation.play("boom")

func manageAttack():
	if(isNearFromTarget(100) and !attackIsLaunched):
		state = STATES.attack
		pass

func isNearFromTarget(distance: float) -> bool:
	return abs(global_position - roseGLobalePosition).x < distance
	
func launchAttack():
	attackIsLaunched = true
	for _i in range(3):
		if state != STATES.attack:
			break
		await get_tree().create_timer(0.5).timeout
		var bullet_instance = BULLET_GUN.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.position = global_position
	# await get_tree().create_timer(reloadingTime).timeout
	if state == STATES.attack:
		state = STATES.fly


func manageDespawn():
	if direction < 0 and global_position.x < limiteToDespawn:
		despawn()
	if direction > 0 and global_position.x > limiteToDespawn:
		despawn()

func despawn():
	on_despawn.emit('copter')
	queue_free()

func manageVerticalDirection():
	var amplitude = position.y - initialPosition.y
	if verticalDirection == 1 and amplitude > verticalAmplitude:
		verticalDirection = -1
	if verticalDirection == -1 and amplitude < 0:
		verticalDirection = 1

func take_damage(attack):
	health -= attack.damage
	


func _on_explosion_animation_animation_finished() -> void:
	on_death.emit(global_position, self)
	queue_free();
