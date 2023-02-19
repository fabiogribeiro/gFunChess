extends Node

func new_game():
	var board = preload("res://scenes/Board.tscn").instance()
	add_child(board)
	$UserInterface.hide()

func quit_game():
	get_tree().quit()
