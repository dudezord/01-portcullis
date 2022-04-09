extends Node2D

func _process(delta):
	$GateHolder/Gate/GateHealthBar.value = $GateHolder/Gate.health
