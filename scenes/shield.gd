extends ZHurtBox

func _on_area_entered(hit_box: Area2D) -> void:
	if hit_box == null: pass
	if !(hit_box is ZHitBox): return
	if hit_box.owner and hit_box.owner.has_method("on_making_damage"):
		hit_box.owner.on_making_damage()
