class_name Spawner
extends Node2D

export(Array, PackedScene) var mob_scenes
export(Array, float) var mob_weights

var _min_timer : float = 1.0;
var _max_timer : float = 3.0;

var _min_speed : float = 200.0;
var _max_speed : float = 200.0;

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if !just_pressed:
		return
	
	for i in range(1, 10):
		if i > mob_scenes.size():
			break
			
		if Input.is_key_pressed(KEY_0 + i):
			_spawn(mob_scenes[i-1])

func _spawn(mob_scene : PackedScene):
	if not mob_scene:
		return
		
	var new_mob = mob_scene.instance()
	new_mob.speed = _min_speed + randf() * (_max_speed - _min_speed)
	add_child(new_mob)

func _get_weighted_index():
	assert(mob_scenes.size() == mob_weights.size())

	var total_weights = 0.0
	
	for w in mob_weights:
		total_weights += w
		
	var r = randf() * total_weights
	
	var idx = 0
	var accum_weight = 0.0
	for w in mob_weights:
		accum_weight += w
		if(accum_weight > r):
			break
		idx += 1

	return idx
	
func set_min_max_timer(min_timer, max_timer):
	_min_timer = min_timer
	_max_timer = max_timer
	
	
func set_min_max_speed(min_speed, max_speed):
	_min_speed = min_speed
	_max_speed = max_speed

func _on_Timer_timeout():
	var idx = _get_weighted_index()
	_spawn(mob_scenes[idx])
		
	$Timer.wait_time = _min_timer + randf() * (_max_timer - _min_timer)
