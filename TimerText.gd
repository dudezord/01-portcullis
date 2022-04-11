extends Label

func _process(delta):
	if($Timer.time_left > 10):
		text = str($Timer.time_left).pad_decimals(0)
	else:
		text = str($Timer.time_left).pad_decimals(1)
