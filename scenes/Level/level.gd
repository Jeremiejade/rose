extends Node2D


const CRS = preload("res://scenes/enemies/enemy_crs.tscn");
const TANK_0 = preload("res://scenes/enemies/tank_0.tscn");
const ENEMY_COPTER = preload("res://scenes/enemies/enemy_copter.tscn");
var rng = RandomNumberGenerator.new();
var random = 1;
var ennemyKillCount = 0;

var spawner

var LIMIT_SPAWN = {
	"tank_0": -1,
	"crs": -1,
	"copter": -1
}
var SPAWN_ENEMIES_COUNT = {
	"tank_0": 0,
	"crs": 0,
	"copter": 0
}

var ENEMIES_KILL_COUNT = {
	"tank_0": 0,
	"crs": 0,
	"copter": 0
}

#const ROUND_1 = [
	#{
		#"name": 'tank_0',
		#"spawnCondition": [
			#
		#],
		#"currentSpawn": 1,
		#"rng": 1
	#},
	#
#]
const ROUND_1 = [
	{
		"name": 'copter',
		"currentSpawn": 1,
		"rng": 1,
		"spawnCondition": []
	},
	{
		"name": 'tank_0',
		"spawnCondition": [
			{
				"name": 'crs',
				"kill": 10
			}
		],
		"currentSpawn": 2,
		"rng": 10
	},
	{
		"name": 'crs',
		"currentSpawn": 15,
		"rng": 2,
		"spawnCondition": []
	}
]

func _ready() -> void:
	$rose.connect("on_update_life", updateRoseLifeProgressBar)
	printScore()
	$CanvasLayer/RoseLifeProgressBar.max_value = gameConfig.rose.life
	updateRoseLifeProgressBar()
	spawner = {
		"bottom": [$SpawnerLeft.position, $SpawneryRight.position],
		"top_1": [$SpawnerTop1Left.position, $SpawnerTop1Right.position]
	}

func addEnnemyByName(enemyName: String, parent: Node2D):
	if enemyName == 'crs':
		var positionAndDirection = getSpawnerPosition()
		addRangeCrs(rng.randi_range(3,9), parent, positionAndDirection)
	if enemyName == 'tank_0':
		var positionAndDirection = getSpawnerPosition()
		addTank0(parent, positionAndDirection)
	if enemyName == 'copter':
		var positionAndDirection = getSpawnerPosition('top_1')
		addCopter(parent, positionAndDirection)

func addRangeCrs(total: int, parent: Node2D, positionAndDirection):
	var pAndD = positionAndDirection
	for index in total:
		await get_tree().create_timer(index * 0.1).timeout
		pAndD[1].x = pAndD[1].x + (50 -pAndD[0])
		addCrs(parent, pAndD)

func addCrs(parent: Node2D, positionAndDirection):
	if SPAWN_ENEMIES_COUNT.crs == LIMIT_SPAWN.crs and LIMIT_SPAWN.crs != -1: return
	var crs = CRS.instantiate()
	addEnnemy(parent, crs, positionAndDirection, 0.4)
	crs.connect('on_death', enemieKillCounter)
	crs.connect('on_death', $rose.pumpBlood)
	SPAWN_ENEMIES_COUNT.crs += 1
	
func addTank0(parent: Node2D, positionAndDirection):
	if SPAWN_ENEMIES_COUNT.tank_0 == LIMIT_SPAWN.tank_0 and LIMIT_SPAWN.tank_0 != -1: return
	var tank = TANK_0.instantiate()
	addEnnemy(parent, tank, positionAndDirection, 0.3)
	tank.connect('on_death', enemieKillCounter)
	SPAWN_ENEMIES_COUNT.tank_0 += 1

func addCopter(parent: Node2D, positionAndDirection):
	var copter = ENEMY_COPTER.instantiate()
	copter.limiteToDespawn = positionAndDirection[2].x
	addEnnemy(parent, copter, positionAndDirection, 0.5)
	copter.connect('on_despawn', enemyDespawn)
	copter.connect('on_death', enemieKillCounter)
	SPAWN_ENEMIES_COUNT.copter += 1

func addEnnemy(parent: Node2D, enemy: Node2D, positionAndDirection, scaling: float = 1):
	enemy.direction = positionAndDirection[0]
	enemy.position = positionAndDirection[1]
	enemy.scale.x = scaling
	enemy.scale.y = scaling
	parent.add_child(enemy)

func enemieKillCounter(_pos, tar):
	ennemyKillCount += 1
	ENEMIES_KILL_COUNT[tar.NAME] += 1
	printScore()
	
func enemyDespawn(targetName):
	SPAWN_ENEMIES_COUNT[targetName] -= 1

func printScore():
	var score := '[color=black][b][font_size=20]';
	var  ENEMIES_KILL_NAMES = ENEMIES_KILL_COUNT.keys();
	var  ENEMIES_KILL_COUNT_VALUES = ENEMIES_KILL_COUNT.values();
	for index in ENEMIES_KILL_NAMES.size():
		score += (str(ENEMIES_KILL_NAMES[index]) + ' : ' + str(ENEMIES_KILL_COUNT_VALUES[index])+ '\n')
		
	$CanvasLayer/SkillCountText2.text =str(score, '[/font_size][/b][/color]')

func updateRoseLifeProgressBar():
	$CanvasLayer/RoseLifeProgressBar.value = gameConfig.rose.life


func getSpawnerPosition(verticalPosition='bottom'):
	random = rng.randf_range(-1, 1)
	if(random > 0): 
		return [1, spawner[verticalPosition][0], spawner[verticalPosition][1]] 
	return [-1,spawner[verticalPosition][1], spawner[verticalPosition][0]]

func completeSpawnCondition(spawnCondition):
	return ENEMIES_KILL_COUNT[spawnCondition.name] >= spawnCondition.kill

func _on_spawner_timer_timeout() -> void:
	# force
	# addCrs(self)
	# addTank0(self)
	# return

	for instruction in ROUND_1:
		if(instruction.spawnCondition.size() > 0):
			if(!instruction.spawnCondition.all(completeSpawnCondition)):
				continue
		var curentSpawn = SPAWN_ENEMIES_COUNT[instruction.name] - ENEMIES_KILL_COUNT[instruction.name]
		if(curentSpawn >= instruction.currentSpawn):
			continue

		var rand = rng.randf_range(0, instruction.rng);
		if(rand <= 1):
			addEnnemyByName(instruction.name, self)
		
