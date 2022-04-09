extends Node2D

func _process(delta):
	$GateHealthBar.value = $GateHolder/Gate.health
