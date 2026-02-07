extends Node2D

const SPEED: int = 900

var isExplosing = false

func _process(delta: float) -> void:
	if(!isExplosing):
		position += transform.x * SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Replace with function body.

func take_ground() -> void:
	if isExplosing: return
	$Bullet.visible = false
	$AnimatedSprite2D.play("boom")
	$AnimatedSprite2D.visible = true
	isExplosing = true

func on_making_damage(target) -> void:
	if isExplosing: return
	if target.material == "ground":
		take_ground()
		return
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
