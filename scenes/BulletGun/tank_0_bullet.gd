extends CharacterBody2D

const SPEED: int = 550

var isExplosing = false
var isLaunched = false
var direction: float

func _process(delta: float) -> void:
	if isExplosing: return
	if(!isLaunched): 
		velocity = Vector2(0,SPEED).rotated(35 * direction) 
		isLaunched = true
	velocity += get_gravity() * delta
	move_and_slide()

func explose() -> void:
	$Tank0Bullet.visible = false
	$AnimatedSprite2D.play("boom")
	$AnimatedSprite2D.visible = true
	call_deferred("disableCollisionShape") 
	isExplosing = true
	
func disableCollisionShape():
	$ZHitBox/CollisionShape2D.disabled = true 

func on_making_damage() -> void:
	print('on_making_damage tank')
	explose()

func take_ground() -> void:
	print('take_ground tank')
	explose()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
