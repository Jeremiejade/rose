class_name ZHitBox extends Area2D

@export var damage = 10
@export var direction = -1
@export var type = "no_name"
@export var collisionShape:CollisionShape2D
@export var ownerNode:Node2D
@export var origin = "player"

func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.name == "Ground" and owner.has_method("take_ground"):
		owner.take_ground()
		if collisionShape:
			call_deferred("disableCollisionShape") 

func disableCollisionShape():
		collisionShape.disabled = true
