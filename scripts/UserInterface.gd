extends Control

signal new_game
signal quit_game

var showMoves = false

func _on_NewGame_pressed():
	emit_signal("new_game")

func _on_Quit_pressed():
	emit_signal("quit_game")


func _on_show_moves_toggled(button_pressed):
	showMoves = button_pressed
