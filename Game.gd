extends Node2D

var _morale : float;

var _min_spawn_timer = 1.0
var _max_spawn_timer = 3.0

var _gate_open_timer = 3.0
var _gate_close_timer = 1.0

var _mob_speed_min = 200.0
var _mob_speed_max = 200.0

export var score_enemy_killed = 7.0
export var score_enemy_enter = -8.0
export var score_enemy_attack = 0.0

export var score_villager_killed = -10.0
export var score_villager_enter = 3.0
export var score_villager_attack = 0.0

export var game_duration = 91.0

export var max_shake_offset = Vector2(7, 7)
export var shake_duration = 0.15

var _delta = 0.0
var _shake_remaining = 0.0

func _ready():
	$Label/Timer.start(game_duration)

	$Spawner.set_min_max_timer(_min_spawn_timer, _max_spawn_timer)
	
	EventBus.connect("mob_killed", self, "_on_Mob_killed")
	EventBus.connect("mob_attacked", self, "_on_Mob_attacked")
	EventBus.connect("mob_despawned", self, "_on_Mob_despawned")
	EventBus.connect("gate_closed", self, "_on_Gate_closed")
	EventBus.connect("gate_destroyed", self, "_on_Gate_destroyed")

func _process(delta):
	_delta = delta
	$GateHolder/GateHealthBar.value = $GateHolder/Gate.health
	
	if(_shake_remaining > 0):
		_shake_remaining -= delta
		shake()
	else:
		$Camera2D.offset.x = 0
		$Camera2D.offset.y = 0
		

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
		$AudioEnemyEntered.pitch_scale = rand_range(0.8, 1.2)
		$AudioEnemyEntered.play(0)

func _add_morale(delta):
	_morale += delta
	_morale = clamp(_morale, 0, 100)
	GameBus.Morale = _morale

	EventBus.emit_signal("morale_updated", _morale)
	
	var _weight = _morale / 100.0

	var ease_spawn = ease(_weight, 0.5)
	_min_spawn_timer = lerp(1.0, 0.01, ease_spawn)
	_max_spawn_timer = lerp(3.0, 1.0, ease_spawn)
	$Spawner.set_min_max_timer(_min_spawn_timer, _max_spawn_timer)
	
	var ease_speed = ease(_weight, 1)
	_mob_speed_min = lerp(200, 150, ease_speed)
	_mob_speed_max = lerp(200, 300, ease_speed)
	$Spawner.set_min_max_speed(_mob_speed_min, _mob_speed_max)
	
	var elapsed_time = 1.0 - $Label/Timer.time_left / game_duration
	var ease_gate = ease(_weight * 0.8 + elapsed_time * 0.2, 0.6)
	_gate_open_timer = lerp(3.0, 0.2, ease_gate)
	_gate_close_timer = lerp(1.0, 0.2, ease_gate)
	$GateHolder/Gate.set_gate_animation_timer(_gate_open_timer, _gate_close_timer)

func _on_Gate_closed():
	$CPUParticles2D.emitting = true
	_shake_remaining = shake_duration
	
func _on_Gate_destroyed():
	$GateHolder.visible = false
	$AudioGateDestroyed.play()
	pass

func shake():
	$Camera2D.offset.x = max_shake_offset.x * rand_range(-1, 1)
	$Camera2D.offset.y = max_shake_offset.y * rand_range(-1, 1)
