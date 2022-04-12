extends Node2D

func _ready():
	EventBus.connect("mob_killed", self, "_on_Mob_killed")
	EventBus.connect("mob_attacked", self, "_on_Mob_attacked")
	EventBus.connect("mob_despawned", self, "_on_Mob_despawned")
	EventBus.connect("gate_destroyed", self, "_on_Gate_destroyed")

func _process(delta):
	$GateHolder/Gate/GateHealthBar.value = $GateHolder/Gate.health

func _on_Mob_killed(mob):
	if(mob is Villager):
		_update_morale(-1)
	elif(mob is EnemySoldier):
		_update_morale(1)

func _on_Mob_attacked(mob, damage):
	if(mob is EnemySoldier):
		_update_morale(-damage)

func _on_Mob_despawned(mob):
	if(mob is Villager):
		_update_morale(1)
	elif(mob is EnemySoldier):
		_update_morale(-1)

func _update_morale(delta):
	EventBus.emit_signal("morale_updated", delta)

func _on_Gate_destroyed():
	get_tree().paused = true

func _on_Timer_timeout():
	get_tree().paused = true
