extends CharacterBody2D

@export var health := 30
@export var direction := 1
@export var verticalAmplitude = 300
@export var limiteToDespawn: float

const NAME = 'copter'
const SPEED = 200.0

var state := 'fly'
var verticalDirection := 1
var initialPosition: Vector2

var isAttacking := false
var attackIsLaunched := false
var reloadingTime := 3

signal on_despawn
signal on_death

const BULLET_GUN = preload("res://scenes/BulletGun/copter_bullet.tscn")


func _ready() -> void:
	$AnimationPlayer.play("rotate_back")
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
		state = "dead"
	
	if state == "fly":
		velocity.x = direction * SPEED
		velocity.y = verticalDirection * SPEED/2
		manageVerticalDirection()
		canAttack()
		if !attackIsLaunched and isAttacking:
			launchAttack()
	if state == 'dead':
		if is_on_floor():
			state = 'explode'
		velocity.x += direction * SPEED/2 * delta
		velocity.y += SPEED * 3 * delta

		if abs(rotation) < PI/4:
			rotation += PI/4 * delta * direction
	if state == 'explode':
		velocity = Vector2(0, 0)
	
	handleAnimation()
	move_and_slide()
	manageDespawn()
	
func handleAnimation():
	if state == 'explode':
		$ExplosionAnimation.visible = true
		$ExplosionAnimation.play("boom")

func canAttack() -> void:
	var roseGLobalePosition = gameConfig.rose.global_position
	if abs(global_position - roseGLobalePosition).x < SPEED and !isAttacking:
		isAttacking = true
	
func launchAttack():
	attackIsLaunched = true
	for _i in range(3):
		if state != 'fly':
			break
		var intialPos = global_position.x
		await get_tree().create_timer(0.5).timeout
		var bullet_instance = BULLET_GUN.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.position = global_position
	await get_tree().create_timer(reloadingTime).timeout
	attackIsLaunched = false
	isAttacking = false


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
