extends CharacterBody2D

var SPEED = 100
var state = 'walk'
var deathHasEmit = false;
@export var health = 10;
@export var direction = -1

signal on_death

var blood;
const BLOOD_BULLET = preload("res://scenes/effect/blood_impact_bullet.tscn");

func _ready() -> void:
	$body.scale.x  = -direction

func _physics_process(delta: float) -> void:
	if health <= 0:
		state = "dead"
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !deathHasEmit :
			on_death.emit(self.global_position, self)
			deathHasEmit = true
	
	if state != "dead" :
		if not is_on_floor():
			velocity += get_gravity() * delta
		if state == 'walk':
			velocity.x = direction * SPEED
		else :
			velocity.x = move_toward(velocity.x, 0, SPEED)
	handleAnimation()
	move_and_slide()
	

func handleAnimation() -> void:
	if state == 'walk':
		$AnimationPlayer.play("walk")
	elif state == 'attack':
		$AnimationPlayer.play("attack")
	elif state == 'dead' and $AnimationPlayer.is_playing():
		$AnimationPlayer.play("death")

func onDieAnimationEnd():
	$AnimationPlayer.stop(true)
	blood.stopEmit()

func eat():
	queue_free()


func addAttack(attack):
	health -= attack.degat
	if attack.type == "bullet":
		var imapctPosition = attack.position.y;
		var headPostion = $body/CrsHead/headBottom.global_position.y
		if imapctPosition < headPostion:
			addBlood($body/CrsHead, attack)
			return
		var bodyPosition = $body/CrsBody/bodyBottom.global_position.y
		if imapctPosition < bodyPosition:
			addBlood($body/CrsBody, attack)
			return
		addBlood($body/CrsFrontLeg, attack)


func addBlood(parent: Sprite2D, attack):
	blood = BLOOD_BULLET.instantiate()
	parent.add_child(blood)
	blood.rotation = attack.rotation
	blood.scale.x  = -direction
	
	blood.global_position = attack.position
	pass

func isEnnemy():
	return true;

func _on_wepon_body_entered(body: Node2D) -> void:
	if body.name == 'rose' || body.name == 'NewPlayer':
		body.addAttack({
				"id": self.get_instance_id(),
				"damage": 10,
				"direction": direction,
			})

func _on_vision_body_entered(body: Node2D) -> void:
	if body.name == 'rose' and state != 'attack':
		state = 'attack'
	if body.name == 'NewPlayer' and state != 'attack':
		state = 'attack'


func _on_vision_body_exited(body: Node2D) -> void:
	if body.name == 'NewPlayer' and state == 'attack':
		state = 'walk'
