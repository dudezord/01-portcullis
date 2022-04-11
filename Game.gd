extends Node2D

func _ready():
	EventBus.connect("gate_destroyed", self, "_on_Gate_destroyed")

func _process(delta):
	$GateHolder/Gate/GateHealthBar.value = $GateHolder/Gate.health

func _on_Gate_destroyed():
	get_tree().paused = true

func _on_Timer_timeout():
	get_tree().paused = true
