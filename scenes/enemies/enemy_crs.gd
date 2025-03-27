extends CharacterBody2D

var SPEED = 100
var direction = -1
var state = 'walk'

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if state == 'walk':
		velocity.x = direction * SPEED
	else :
		velocity.x = move_toward(velocity.x, 0, SPEED)
	handleAnimation()
	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'rose' and state != 'attack':
		state = 'attack'
		

func handleAnimation() -> void:
	if state == 'walk':
		$AnimationPlayer.play("walk")
	elif state == 'attack':
		$AnimationPlayer.play("attack")



func _on_wepon_body_entered(body: Node2D) -> void:
	if body.name == 'rose' :
		body.addCRSAttack({
				"id": self.get_instance_id(),
				"damage": 10
			})
