extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0

var isJumping = false


func _physics_process(delta: float) -> void:
	print($AnimationPlayer.speed_scale)
	$AnimationPlayer.speed_scale = SPEED / 100
	# Add the gravity.
	if is_on_floor():
		isJumping = false

	else:
		velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		isJumping = true
		$AnimationPlayer.play("idle")



	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)	
		
	if direction != 0 and !isJumping:
		if direction < 0:
			$AnimationPlayer.play("walkLeft")
		else: 
			$AnimationPlayer.play("walkRight")

	else:
		$AnimationPlayer.play("idle")

	move_and_slide()
