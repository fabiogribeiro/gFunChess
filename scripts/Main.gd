extends Node

var board

func new_game():
	board = preload("res://scenes/Board.tscn").instance()
	board.showLegalMoves = $UserInterface/ShowMoves.pressed
	board.connect("checkmate", self, "checkmate")
	add_child(board)
	$UserInterface.hide()

func checkmate(winner):
	board.queue_free()
	$UserInterface.show()

	if winner:
		$Message.text = "Black wins!"
	else:
		$Message.text = "White wins!"
	$Message.show()
	yield(get_tree().create_timer(3), "timeout")
	$Message.hide()

func quit_game():
	get_tree().quit()
