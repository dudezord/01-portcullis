extends ProgressBar

func _ready():
	EventBus.connect("morale_updated", self, "_on_Morale_updated")
	pass

func _on_Morale_updated(new_value):
	value = clamp(new_value, 0, 100)
	pass
