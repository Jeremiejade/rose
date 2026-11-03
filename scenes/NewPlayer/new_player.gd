class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEIGHT := 1000;

var VJumpVelocity = JUMP_VELOCITY

var slidingState = { 
	"isActive": false,
	"direction": 0,
	"puissance": 0,
	};

var ATTACKS = []

signal on_update_amo

func _ready() -> void:
	gameConfig.player = self
	$sprites/Gun.connect('on_amo_update', updateAmo)

func _physics_process(delta: float) -> void:
	for attack in ATTACKS:
		damageTakenManager(attack)
	ATTACKS = []
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	if slidingState.isActive:
		sliding(direction, delta)
	else: 
		if is_on_floor() and rotation == 0:
			movingOnTheFloor(direction)
		else:
			flying(direction, delta)
			
	if Input.is_action_just_pressed("jump") and is_on_floor() and rotation == 0:
		velocity.y = JUMP_VELOCITY
		
	var animationState = _animationState(direction, slidingState.isActive);
	$AnimationPlayer.play(animationState)
	var oldVelocity = Vector2(velocity)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if !slidingState.isActive :
			bounceManagement(collision.get_collider(), oldVelocity)
	limitVelocity()
	
	
func limitVelocity():
	if abs(velocity.x) > SPEED * 3:
		if(velocity.x > 0):
			velocity.x = SPEED * 3
		else :
			velocity.x = -SPEED * 3
	if abs(velocity.y) > SPEED * 3:
		if(velocity.y > 0):
			velocity.y = SPEED * 3
		else :
			velocity.y = -SPEED * 3
			
func damageTakenManager(attack):
	slidingState.puissance = attack.damage * SPEED / 4
	if attack.origin == "tankShield":
		velocity = (attack.position - $Center.global_position) * -2
	else :
		velocity.x = slidingState.puissance * attack.direction
	slidingState.isActive = true
	slidingState.direction = attack.direction

func sliding(playerDirection, delta):
	if abs(velocity.x) > SPEED:
		var modifier = 600;
		if playerDirection == -slidingState.direction :
			modifier = 1200;
		velocity.x += (slidingState.puissance / abs(velocity.x)) * modifier * delta * -slidingState.direction 
	else:
		slidingState.isActive = false;

func bounceManagement(collider: CollisionObject2D, oldVelocity: Vector2) -> void:
	if collider.name == "Wall":
		velocity.x = -(oldVelocity.x/1.5)
	
	if collider.name == "Ground":
		if (rotation < 1 and rotation > -1) or oldVelocity.y < 300:
			rotation = 0
		else: 
			velocity.y = -(oldVelocity.y/2)
	
func flying(direction: float, delta: float) -> void:
	if direction != 0:
		rotate(direction * delta * 3)
	if Input.is_action_pressed("jump"):
		$sprites/PowerFuel.start = true
		var v = Vector2(0,VJumpVelocity).rotated(rotation)
		velocity += v * delta * 3.5
	if (position.y > -MAX_HEIGHT):
		VJumpVelocity = JUMP_VELOCITY;
	else:
		
		var deltaPos;
		if(abs(position.y + MAX_HEIGHT) < 10):
			deltaPos = 1 
		else :
			deltaPos = abs(position.y + MAX_HEIGHT) / 10
		VJumpVelocity = JUMP_VELOCITY +  deltaPos
	
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
	if(!attack.origin.begins_with('player')):
		ATTACKS.push_front(attack)

func updateAmo(state, size):
	on_update_amo.emit(state, size)
