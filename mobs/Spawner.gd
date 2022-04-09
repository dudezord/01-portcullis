class_name Spawner
extends Node2D

export(PackedScene) var enemy_scene
export(PackedScene) var villager_scene

export(Array, PackedScene) var mob_scenes
export(Array, float) var mob_weights

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if !just_pressed:
		return
	
	for i in range(1, 10):
		if Input.is_key_pressed(KEY_0 + i):
			_spawn(mob_scenes[i-1])

func _spawn(mob_scene : PackedScene):
	if not mob_scene:
		return
		
	add_child(mob_scene.instance())

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
	
func _on_Timer_timeout():
	var idx = _get_weighted_index()
	_spawn(mob_scenes[idx])
		
	$Timer.wait_time = 1 + randf() * 2 # [1.0, 3.0]
