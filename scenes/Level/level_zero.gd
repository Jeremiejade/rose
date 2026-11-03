extends Node2D

var amos := []

func _ready() -> void:
	$NewPlayer.connect('on_update_amo', updateAmo)
	amos = [
	$CanvasLayer/PlayerAmoContainer/Amo0,
	$CanvasLayer/PlayerAmoContainer/Amo1,
	$CanvasLayer/PlayerAmoContainer/Amo2,
	$CanvasLayer/PlayerAmoContainer/Amo3,
	$CanvasLayer/PlayerAmoContainer/Amo4,
	$CanvasLayer/PlayerAmoContainer/Amo5,
	]



func updateAmo(state, size):
	if(state == "reload"):
		for index in size:
			if(index == size):
				break
			amos[index - size].visible = true;
			await get_tree().create_timer(1/gameConfig.player_max_bullet).timeout;
		return
		
	amos[gameConfig.player_amo].visible = false;
	return
