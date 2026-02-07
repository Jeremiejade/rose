class_name ZHurtBox extends Area2D

@export var material_type = "no_name"

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hit_box: Area2D) -> void:
	if hit_box == null: pass
	if !(hit_box is ZHitBox): return
	if owner.has_method("take_damage"):
		owner.take_damage({
			"damage": hit_box.damage,
			"direction": hit_box.direction,
			"rotation": hit_box.global_rotation,
			"position": hit_box.global_position,
			"type": hit_box.type,
			"origin": hit_box.origin
		})
	if hit_box.owner and hit_box.owner.has_method("on_making_damage"):
		hit_box.owner.on_making_damage({
			"material": material_type
		})
