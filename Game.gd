extends Node2D

var _morale : float;

export var score_enemy_killed = 5.0
export var score_enemy_enter = -2.0
export var score_enemy_attack = -2.0

export var score_villager_killed = -2.0
export var score_villager_enter = 5.0
export var score_villager_attack = 0.0

var _delta = 0.0

func _ready():
	EventBus.connect("mob_killed", self, "_on_Mob_killed")
	EventBus.connect("mob_attacked", self, "_on_Mob_attacked")
	EventBus.connect("mob_despawned", self, "_on_Mob_despawned")
	EventBus.connect("gate_destroyed", self, "_on_Gate_destroyed")

func _process(delta):
	_delta = delta
	$GateHolder/Gate/GateHealthBar.value = $GateHolder/Gate.health

func _input(event):
	if event.is_action_pressed("ui_page_up"):
		_add_morale(1)
	if event.is_action_pressed("ui_page_down"):
		_add_morale(-1)
		
func _on_Mob_killed(mob):
	if(mob is Villager):
		_add_morale(score_villager_killed)
	elif(mob is EnemySoldier):
		_add_morale(score_enemy_killed)

func _on_Mob_attacked(mob, damage):
	if(mob is Villager):
		_add_morale(_delta * score_villager_attack)
	if(mob is EnemySoldier):
		_add_morale(_delta * score_enemy_attack)

func _on_Mob_despawned(mob):
	if(mob is Villager):
		_add_morale(score_villager_enter)
	elif(mob is EnemySoldier):
		_add_morale(score_enemy_enter)

func _add_morale(delta):
	_morale += delta
	EventBus.emit_signal("morale_updated", _morale)

func _on_Gate_destroyed():
	get_tree().paused = true

func _on_Timer_timeout():
	get_tree().paused = true
