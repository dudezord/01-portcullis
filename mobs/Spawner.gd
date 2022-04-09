class_name Spawner
extends Node2D

export(PackedScene) var enemy_scene
export(PackedScene) var villager_scene

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if !just_pressed:
		return
	
	if Input.is_key_pressed(KEY_1):
		_spawn(enemy_scene.instance())
	if Input.is_key_pressed(KEY_2):
		_spawn(villager_scene.instance())

func _spawn(mob : Node2D):
	if not mob:
		return
		
	add_child(mob)

func _on_Timer_timeout():
	var r = randf()
	
	if r < randf():
		_spawn(enemy_scene.instance())
	else:
		_spawn(villager_scene.instance())
		
	$Timer.wait_time = 1 + randf() * 2; # [1.0, 3.0]
