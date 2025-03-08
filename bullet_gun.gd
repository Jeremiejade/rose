extends Node2D

const SPEED: int = 900

var isExplosing = false

func _process(delta: float) -> void:
	if(!isExplosing):
		position += transform.x * SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Replace with function body.


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if(body.name == "Ground" and !isExplosing):
		$Bullet.visible = false
		$AnimatedSprite2D.play("boom")
		$AnimatedSprite2D.visible = true
		isExplosing = true

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
