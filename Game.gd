extends Node2D

func _process(delta):
	$GateHolder/Gate/GateHealthBar.value = $GateHolder/Gate.health

func _on_Timer_timeout():
	get_tree().paused = true
