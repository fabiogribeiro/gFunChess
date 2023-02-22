extends Node

var board

func new_game():
	board = preload("res://scenes/Board.tscn").instance()
	board.showLegalMoves = $UserInterface/ShowMoves.pressed
	board.connect("mate", self, "mate")
	add_child(board)
	$UserInterface.hide()

func mate(winner):
	board.queue_free()
	$UserInterface.show()

	if winner == 1:
		$Message.text = "Black wins!"
	elif winner == 0:
		$Message.text = "White wins!"
	else:
		$Message.text = "It's a draw."
	$Message.show()
	yield(get_tree().create_timer(3), "timeout")
	$Message.hide()

func quit_game():
	get_tree().quit()
