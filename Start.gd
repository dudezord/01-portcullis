extends Node2D

var Game = preload("res://Game.tscn")
func _ready():
	EventBus.connect("gate_destroyed", self, "_on_Gate_destroyed")
	show_menu("")
	$Menu/StartButton.text = "Start"

func _on_StartButton_pressed():
	hide_menu()
	$Game.queue_free()
	remove_child($Game)
	
	var new_game = Game.instance()
	new_game.name = "Game"
	
	add_child(new_game)
	move_child(new_game, 0)
	$Game/Label/Timer.connect("timeout", self, "_on_Timer_timeout")

func show_menu(message):
	_show_or_hide_menu_ui(true)
	$Menu/Message.text = message
	$Menu/StartButton.text = "Play again"
	
func hide_menu():
	_show_or_hide_menu_ui(false)
	$Menu/Message.text = ""
	
func _show_or_hide_menu_ui(show_menu):
	$Menu.visible = show_menu
	$Game/Label.visible = !show_menu
	$Game/MoraleBar.visible = !show_menu
	get_tree().paused = show_menu

func _on_Gate_destroyed():
	show_menu("You lose.\nThe Portcullis was destroyed!")

func _on_Timer_timeout():
	show_menu("You survived.\n You finished with %d%% Morale." % GameBus.Morale)
