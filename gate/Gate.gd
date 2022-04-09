extends Node2D

enum Status {
	Opened,
	Opening,
	Closed,
	Closing
}

var status = Status.Closed

func _ready():
	pass

func _process(delta):
	var can_kill = (status != Status.Opening)
	
	$AreaKill.visible = can_kill
	$AreaKill/CollisionPolygon2D.disabled = !can_kill

func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
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
