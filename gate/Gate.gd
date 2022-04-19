extends Node2D

export(float, 0, 100, 0.1) var health = 100.0

enum Status {
	Opened,
	Opening,
	Closed,
	Closing
}

var status = Status.Closed

var _original_open_timer = 0.0
var _open_timer = 0.0
var _original_close_timer = 0.0
var _close_timer = 0.0

func _ready():
	_original_open_timer = $AnimationPlayer.get_animation("open_gate").length
	_original_close_timer = $AnimationPlayer.get_animation("close_gate").length
	_open_timer = _original_open_timer
	_close_timer = _original_close_timer
	
	EventBus.connect("gate_damaged", self, "_on_damage_received")
	pass

func _process(delta):
	var can_kill = (status != Status.Opening)
	
	$AreaKill.visible = can_kill
	$AreaKill/CollisionPolygon2D.disabled = !can_kill

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if status == Status.Opened:
			status = Status.Closing
			$AnimationPlayer.playback_speed = _original_close_timer / _close_timer
			$AnimationPlayer.play("close_gate")
			
		elif status == Status.Closed:
			status = Status.Opening
			if _open_timer < _original_open_timer * 0.33:
				$AnimationPlayer.playback_speed = _original_open_timer / _open_timer * 0.33
				$AnimationPlayer.play("open_gate_fastest")
			elif _open_timer < _original_open_timer * 0.66:
				$AnimationPlayer.playback_speed = _original_open_timer / _open_timer * 0.66
				$AnimationPlayer.play("open_gate_fast")
			else:
				$AnimationPlayer.playback_speed = _original_open_timer / _open_timer
				$AnimationPlayer.play("open_gate")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"open_gate", "open_gate_fast", "open_gate_fastest":
			status = Status.Opened
		"close_gate":
			status = Status.Closed
			

func _on_AreaStop_area_entered(area):
	area.owner.emit_signal("stop")
	pass

func _on_AreaStop_area_exited(area):
	area.owner.emit_signal("move")
	pass

func _on_AreaKill_area_entered(area):
	area.owner.emit_signal("die")
	pass
	
func set_gate_animation_timer(open_timer, close_timer):
	_open_timer = open_timer
	_close_timer = close_timer
	
func _on_damage_received(damage):
	health -= damage
	
	if(health <= 0):
		EventBus.emit_signal("gate_destroyed")
