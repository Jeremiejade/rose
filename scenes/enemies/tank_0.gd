extends CharacterBody2D

var SPEED := 50

@export var health := 10;
@export var direction := -1

var state := 'walk'

func _ready() -> void:
	$Body.scale.x  = -direction * $Body.scale.x


func _physics_process(delta: float) -> void:

	if state != "dead" :
		if not is_on_floor():
			velocity += get_gravity() * delta
		if state == 'walk':
			velocity.x = direction * SPEED
		else :
			velocity.x = move_toward(velocity.x, 0, SPEED)
	handlePositionShield()
	move_and_slide()
	
func handlePositionShield():
	var player = gameConfig.player;
	var shield = $Tank0Shield
	if !player: return
	var angle = ($Tank0Shield/center.global_position - player.position).angle()
	if angle < 0 :
		if angle < -2:  angle = PI
		else:  angle = 0
	shield.rotation = angle
