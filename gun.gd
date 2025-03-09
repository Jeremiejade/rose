extends Sprite2D

const BULLET_GUN = preload("res://scenes/BulletGun/bullet_gun.tscn")

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire"): 
		var bullet_instance = BULLET_GUN.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = $Target.global_position
		bullet_instance.rotation = global_rotation
