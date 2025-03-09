extends Node2D

var start = false
func _process(_delta: float) -> void:
	if start:
		$CPUParticles2D.emitting = true;
		start = false
