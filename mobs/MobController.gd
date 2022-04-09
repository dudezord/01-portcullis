extends Node2D

export var speed = 200
export var score_death = 500

enum Status {
	Moving,
	Stopped,
	Dead
}

var _status = Status.Moving

signal stop
signal move
signal die

export var debug = false
export (float, 0, 20, 0.1) var damage_per_second = 0

func _ready():
	connect("stop", self, "_on_Mob_stop")
	connect("move", self, "_on_Mob_move")
	connect("die", self, "_on_Mob_die")
	pass

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()

	if Input.is_key_pressed(KEY_TAB) and just_pressed:
		debug = !debug

func _process(delta):
	if(_status == Status.Stopped):
		_attack(delta)
		return

	_move(delta)
	
func _move(delta):
	var delta_x = speed * delta
	
	if debug:
		delta_x = 0
		
		if Input.is_key_pressed(KEY_LEFT):
			delta_x -= speed * delta
			
		if Input.is_key_pressed(KEY_RIGHT):
			delta_x += speed * delta
	
	position.x += delta_x
	
func _attack(delta):
	if not _colliding_object:
		return
		
	_colliding_object.emit_signal("damage", damage_per_second * delta)

func _on_Mob_die():
	_status = Status.Dead
	queue_free()

func _on_Mob_stop():
	_status = Status.Stopped

func _on_Mob_move():
	_status = Status.Moving
	
var _colliding_object : Node2D

func _on_AreaStop_area_entered(area):
	_colliding_object = area.owner as Node2D
