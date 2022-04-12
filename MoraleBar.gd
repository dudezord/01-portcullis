extends ProgressBar

func _ready():
	EventBus.connect("morale_updated", self, "_on_Morale_updated")
	pass

func _on_Morale_updated(delta):
	value = clamp(value + delta, 0, 100)
	pass
