extends Node2D


enum PieceColor {WHITE, BLACK}
export(PieceColor) var ownColor

var squareNumber
var hasMoved = false

func setInSquare():
	var SQ_SIZE = Utils.SQ_SIZE
	position.x = int(position.x / SQ_SIZE) * SQ_SIZE + SQ_SIZE/2
	position.y = int(position.y / SQ_SIZE) * SQ_SIZE + SQ_SIZE/2

func getLegalSquares(board):
	pass

func getValidSquare(move):
	var pos = Utils.squareToCoordsInt(squareNumber)
	pos[0] += move[0]
	pos[1] += move[1]

	if pos[0] >= 0 and pos[0] < 8 and pos[1] >= 0 and pos[1] < 8:
		return Utils.intCoordsToSquare(pos[0], pos[1])
	
	return null

func boardInit(board):
	var square = Utils.coordsToSquare(position.x, position.y)
	squareNumber = square
	board[square] = self
	setInSquare()
