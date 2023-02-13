extends Node

const SQ_SIZE = 64

var board = []
var selectedPiece = null

func _ready():
	board.resize(64)
	board.fill(null)

	board[0] = $BKing
	$BKing.squareNumber = 0

	board[2] = $WKing
	$WKing.squareNumber = 2

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var brd_index = Utils.coordsToSquare(event.position.x, event.position.y)
		var pieceUnder = board[brd_index]

		if (not selectedPiece) and pieceUnder:
			selectedPiece = pieceUnder
			selectedPiece.z_index = 1
			board[brd_index] = null
	
		if selectedPiece and not event.pressed:
			if isMove(selectedPiece, brd_index) and isKingSafe(selectedPiece, brd_index):
				if board[brd_index]:
					board[brd_index].queue_free()
				board[brd_index] = selectedPiece
				selectedPiece.squareNumber = brd_index
			else:
				board[selectedPiece.squareNumber] = selectedPiece
				selectedPiece.position = Utils.squareToCoords(selectedPiece.squareNumber)

			selectedPiece.setInSquare()
			selectedPiece.z_index = 0
			selectedPiece = null
			
	if event is InputEventMouseMotion and selectedPiece:
		selectedPiece.position = event.position

func isMove(piece, square):
	return selectedPiece.getLegalSquares(board).has(square)

# Check for king safety
func isKingSafe(piece, square):
	var test_board = board.duplicate()
	test_board[piece.squareNumber] = null
	test_board[square] = piece


	var king = $WKing;
	if king.ownColor != piece.ownColor:
		king = $BKing

	var squares = []
	for test_piece in test_board:
		if test_piece:
			if test_piece.ownColor != piece.ownColor:
				squares.append_array(test_piece.getLegalSquares(test_board))

	return not squares.has(square)
