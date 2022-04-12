extends Node2D

export(float, 0, 100, 0.1) var health = 100.0

signal damage

enum Status {
	Opened,
	Opening,
	Closed,
	Closing
}

var status = Status.Closed

func _ready():
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
			$AnimationPlayer.play("close_gate")
			
		elif status == Status.Closed:
			status = Status.Opening
			$AnimationPlayer.play("open_gate")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "open_gate":
		status = Status.Opened
	elif anim_name == "close_gate":
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
	
func _on_damage_received(damage):
	health -= damage
	
	if(health <= 0):
		EventBus.emit_signal("gate_destroyed")
