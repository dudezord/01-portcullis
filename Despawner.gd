extends Node2D

func _on_Area2D_area_entered(area):
	area.owner.emit_signal("despawn")
