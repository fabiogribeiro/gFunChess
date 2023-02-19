extends Control

signal new_game
signal quit_game


func _on_NewGame_pressed():
	emit_signal("new_game")

func _on_Quit_pressed():
	emit_signal("quit_game")
