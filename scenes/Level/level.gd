extends Node2D

const CRS = preload("res://scenes/enemies/enemy_crs.tscn");
const TANK_0 = preload("res://scenes/enemies/tank_0.tscn");
var rng = RandomNumberGenerator.new();
var random = 1;

var ennemyKillCount = 0;

var LIMIT_SPAWN = {
	"tank": 1,
	"crs": 0
}
var SPAWN_ENEMIES_COUNT = {
	"tank": 0,
	"crs": 0
}


func addCrs(parent: Node2D):
	if SPAWN_ENEMIES_COUNT.crs == LIMIT_SPAWN.crs and LIMIT_SPAWN.crs != -1: return
	var crs = CRS.instantiate()
	addEnnemy(parent, crs)
	crs.connect('on_death', enemieKillCounter)
	crs.connect('on_death', $rose.pumpBlood)
	
	SPAWN_ENEMIES_COUNT.crs += 1
	
func addTank0(parent: Node2D):
	if SPAWN_ENEMIES_COUNT.tank == LIMIT_SPAWN.tank and LIMIT_SPAWN.tank != -1: return
	var tank = TANK_0.instantiate()
	addEnnemy(parent, tank)
	SPAWN_ENEMIES_COUNT.tank += 1
	
func addEnnemy(parent: Node2D, enemy: Node2D):
	var positionAndDirection = getSpawnerPosition()
	enemy.direction = positionAndDirection[0]
	enemy.position = positionAndDirection[1]
	enemy.scale.x = 0.3
	enemy.scale.y = 0.3
	parent.add_child(enemy)

func enemieKillCounter(_pos, _tar):
	ennemyKillCount += 1
	$CanvasLayer/SkillCountText2.text = str('[color=black][b][font_size=30]',ennemyKillCount,'[/font_size][/b][/color]' )

func getSpawnerPosition():
	random = rng.randf_range(-1, 1)
	if(random > 0): 
		return [1, $SpawnerLeft.position] 
	return [-1, $SpawneryRight.position]



func _on_spawner_timer_timeout() -> void:
	var rand = rng.randf_range(-1, 1)
	if rand > 0 :
		addCrs(self)
		return
	addTank0(self)
