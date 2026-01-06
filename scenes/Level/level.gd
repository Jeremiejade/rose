extends Node2D

const CRS = preload("res://scenes/enemies/enemy_crs.tscn");
var rng = RandomNumberGenerator.new();
var random = 1;

var ennemyKillCount = 0;


func addCrs(parent: Node2D):
	var crs = CRS.instantiate()
	var positionAndDirection = getSpawnerPosition()
	crs.direction = positionAndDirection[0]
	crs.position = positionAndDirection[1]
	crs.scale.x = 0.5
	crs.scale.y = 0.5
	crs.connect('on_death', enemieKillCounter)
	crs.connect('on_death', $rose.pumpBlood)
	
	
	parent.add_child(crs)

func enemieKillCounter(_pos, _tar):
	ennemyKillCount += 1
	$SkillCountText2.text = str('[color=black][b][font_size=30]',ennemyKillCount,'[/font_size][/b][/color]' )

func getSpawnerPosition():
	random = rng.randf_range(-1, 1)
	if(random > 0): 
		return [1, $SpawnerLeft.position] 
	return [-1, $SpawneryRight.position]


func _on_spawner_timer_timeout() -> void:
	addCrs(self)
