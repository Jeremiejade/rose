extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const TOTAL_JUMP_FUEL = 300
var curentJumpFuel = TOTAL_JUMP_FUEL;
var jumpFuelIsLoad = false

func _physics_process(delta: float) -> void: 
	$sprites/FrontLeg/FuelGauge.value = (curentJumpFuel / TOTAL_JUMP_FUEL)*100
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		if curentJumpFuel < TOTAL_JUMP_FUEL:
			curentJumpFuel += 1000 * delta
		else:
			curentJumpFuel = TOTAL_JUMP_FUEL

	if Input.is_action_pressed("jump") and curentJumpFuel > 0:
		velocity.y = JUMP_VELOCITY
		curentJumpFuel -= 500 * delta

	var direction = Input.get_axis("move_left", "move_right")
	if direction < 0:
		$sprites.scale.x = 1
	elif  direction > 0: 
		$sprites.scale.x = -1
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var animationState = _animationState(direction);
	$AnimationPlayer.play(animationState)
	move_and_slide()

func _animationState(direction: float) -> String:
	if not is_on_floor():
		return "jump"
	if direction: 
		return "walk"
	return "idle"
