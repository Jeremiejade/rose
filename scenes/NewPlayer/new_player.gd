extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const TOTAL_JUMP_FUEL = 300
var curentJumpFuel = TOTAL_JUMP_FUEL;
var jumpFuelIsLoad = false

func _physics_process(delta: float) -> void: 
	$sprites/FrontLeg/FuelGauge.value = (curentJumpFuel / TOTAL_JUMP_FUEL) * 100
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		if curentJumpFuel < TOTAL_JUMP_FUEL:
			curentJumpFuel += 1000 * delta
		elif curentJumpFuel > TOTAL_JUMP_FUEL:
			curentJumpFuel = TOTAL_JUMP_FUEL



	var direction = Input.get_axis("move_left", "move_right")
	if is_on_floor():
		movingOnTheFloor(direction)
	else:
		flying(direction, delta)
		
	if Input.is_action_just_pressed("jump") and curentJumpFuel > 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		curentJumpFuel -= 500 * delta

	var animationState = _animationState(direction);
	$AnimationPlayer.play(animationState)
	move_and_slide()
	
func flying(direction: float, delta: float) -> void:
	if direction != 0:
		rotate(direction * delta)
	if Input.is_action_pressed("jump") and curentJumpFuel > 0:
		var v = Vector2(0,JUMP_VELOCITY).rotated(rotation)
		curentJumpFuel -= 500 * delta
		velocity += v * delta * 3.5
	
func movingOnTheFloor(direction: float) -> void:
	if direction != 0:
		$sprites.scale.x = -direction
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _animationState(direction: float) -> String:
	if not is_on_floor():
		return "jump"
	if direction: 
		return "walk"
	return "idle"
