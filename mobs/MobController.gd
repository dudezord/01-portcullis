extends Node2D

export var speed = 200
export var score_death = 500

var _defaultSpeed = 0

signal stop
signal move
signal die

export var debug = false

func _ready():
	_defaultSpeed = speed
	connect("stop", self, "_on_Mob_stop")
	connect("move", self, "_on_Mob_move")
	connect("die", self, "_on_Mob_die")
	pass

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()

	if Input.is_key_pressed(KEY_TAB) and just_pressed:
		debug = !debug

func _process(delta):
	var delta_x = speed * delta
	
	if debug:
		delta_x = 0
		
		if Input.is_key_pressed(KEY_LEFT):
			delta_x -= speed * delta
			
		if Input.is_key_pressed(KEY_RIGHT):
			delta_x += speed * delta
	
	position.x += delta_x

func _on_Mob_die():
	queue_free()

func _on_Mob_stop():
	speed = 0

func _on_Mob_move():
	speed = _defaultSpeed
