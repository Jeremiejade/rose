extends Camera2D

const POSITION_NEUTRAL := 460;
const POSITION_MAX := 1001
const POSIITON_BOTTOM := 0

func _process(_delta: float) -> void:
	self.offset.y = POSIITON_BOTTOM;
	var position = gameConfig.player.global_position
	self.position.x = position.x;
	var positionV: int = abs(position.y + POSITION_NEUTRAL);
	
	if( position.y > -POSITION_NEUTRAL):	
		self.zoom.x = 1;
		self.zoom.y = 1;
		return
	if(positionV > 1000):
		self.offset.y = 1000 - positionV;
		return
	var zoom: float =  0.51 * positionV / POSITION_MAX;
	self.zoom.x = 1 - zoom;
	self.zoom.y = 1 - zoom;
	pass

func shake():
	pass
