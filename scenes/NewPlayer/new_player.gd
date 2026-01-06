extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const TOTAL_JUMP_FUEL = 300
var curentJumpFuel = TOTAL_JUMP_FUEL;
var jumpFuelIsLoad = false;
var slidingState = { 
	"isActive": false,
	"direction": 0,
	"puissance": 0,
	};

var ATTACKS = []

func _physics_process(delta: float) -> void:
	for attack in ATTACKS:
		slidingState.puissance = attack.damage * SPEED / 4
		velocity.x = slidingState.puissance * attack.direction
		slidingState.isActive = true
		slidingState.direction = attack.direction
		ATTACKS = []
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var threshold = round(curentJumpFuel * 100 ) / TOTAL_JUMP_FUEL
	$sprites/FrontLeg/FuelGauge.value = round(threshold)
	refielFuel(delta)

	var direction = Input.get_axis("move_left", "move_right")
	if slidingState.isActive:
		sliding(direction, delta)
	else: 
		if is_on_floor() and rotation == 0:
			movingOnTheFloor(direction)
		else:
			flying(direction, delta)
			
	if Input.is_action_just_pressed("jump") and curentJumpFuel > 0 and is_on_floor() and rotation == 0:
		velocity.y = JUMP_VELOCITY

	var animationState = _animationState(direction, slidingState.isActive);
	$AnimationPlayer.play(animationState)
	var oldVelocity = Vector2(velocity)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		bounceManagement(collision.get_collider().name, oldVelocity)
	

func refielFuel(delta: float) -> void:
	if is_on_floor():
		if curentJumpFuel < TOTAL_JUMP_FUEL:
			curentJumpFuel += 1000 * delta
		elif curentJumpFuel > TOTAL_JUMP_FUEL:
			curentJumpFuel = TOTAL_JUMP_FUEL

func sliding(playerDirection, delta):
	if abs(velocity.x) > SPEED:
		var modifier = 600;
		if playerDirection == -slidingState.direction :
			modifier = 1200;
		velocity.x += (slidingState.puissance / abs(velocity.x)) * modifier * delta * - slidingState.direction 

	else:
		slidingState.isActive = false;

func bounceManagement(colliderName: String, oldVelocity: Vector2) -> void:
	if colliderName == "Wall":
		velocity.x = -(oldVelocity.x/1.5)
	if colliderName == "Ground":
		if (rotation < 1 and rotation > -1) or oldVelocity.y < 300:
			rotation = 0
		else: 
			velocity.y = -(oldVelocity.y/2)
	
func flying(direction: float, delta: float) -> void:
	if direction != 0:
		rotate(direction * delta * 3)
	if Input.is_action_pressed("jump") and curentJumpFuel > 0:
		$sprites/PowerFuel.start = true
		var v = Vector2(0,JUMP_VELOCITY).rotated(rotation)
		curentJumpFuel -= 500 * delta
		velocity += v * delta * 3.5
	
func movingOnTheFloor(direction: float) -> void:
	if direction != 0:
		$sprites.scale.x = -direction
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _animationState(direction: float, _isSliding: bool) -> String:
	if not is_on_floor():
		return "jump"
	if direction: 
		return "walk"
	return "idle"

func take_damage(attack) :
	ATTACKS.push_front(attack)
