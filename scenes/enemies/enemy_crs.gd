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
	print(body.name)
	if body.name == 'rose':
		state = 'attack'

func handleAnimation() -> void:
	if state == 'walk':
		$AnimationPlayer.play("walk")
	elif state == 'attack':
		$AnimationPlayer.play("attack")
