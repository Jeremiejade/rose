class_name ZHurtBox extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hit_box: ZHitBox) -> void:
	print(hit_box)
	if hit_box != null and owner.has_method("take_damage"):
		owner.take_damage({
			"damage": hit_box.damage,
			"direction": hit_box.direction
		})
