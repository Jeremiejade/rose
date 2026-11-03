extends Sprite2D

const BULLET_GUN = preload("res://scenes/BulletGun/bullet_gun.tscn")
const RELOAD_TIME := 1;
const MAX_BULLETS := 6;
var isReloading := false

signal on_amo_update

func _ready() -> void:
	gameConfig.player_max_bullet = MAX_BULLETS;
	gameConfig.player_amo = gameConfig.player_max_bullet;

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if(isReloading):
		return
		
	if Input.is_action_just_pressed("reload") and gameConfig.player_amo != gameConfig.player_max_bullet:
		reloading()
		
	if Input.is_action_just_pressed("fire") and gameConfig.player_amo == 0: 
		reloading()
		
	if Input.is_action_just_pressed("fire") and gameConfig.player_amo > 0: 
		var bullet_instance = BULLET_GUN.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = $Target.global_position
		bullet_instance.rotation = global_rotation
		gameConfig.player_amo -= 1
		on_amo_update.emit("fire", 0)
		
func reloading():
	isReloading = true
	var reloadTimeV = gameConfig.player_max_bullet - gameConfig.player_amo;
	var timeToRelaod = reloadTimeV * (RELOAD_TIME / gameConfig.player_max_bullet)
	on_amo_update.emit("reload", reloadTimeV)
	await get_tree().create_timer(timeToRelaod).timeout;
	isReloading = false
	gameConfig.player_amo = gameConfig.player_max_bullet;
