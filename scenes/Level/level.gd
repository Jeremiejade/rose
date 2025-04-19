extends Node2D

const CRS = preload("res://scenes/enemies/enemy_crs.tscn");
var rng = RandomNumberGenerator.new();
var random = 1;


	
func addCrs(parent: Node2D):
	var crs = CRS.instantiate()
	var positionAndDirection = getSpawnerPosition()
	crs.direction = positionAndDirection[0]
	crs.position = positionAndDirection[1]
	crs.scale.x = 0.5
	crs.scale.y = 0.5
	
	parent.add_child(crs)


func getSpawnerPosition():
	random = rng.randf_range(-1, 1)
	if(random > 0): 
		return [1, $SpawnerLeft.position] 
	return [-1, $SpawneryRight.position]


func _on_spawner_timer_timeout() -> void:
	addCrs(self)
