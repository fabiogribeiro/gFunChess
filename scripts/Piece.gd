extends Node2D


enum PieceColor {WHITE, BLACK}
export(PieceColor) var ownColor

const SQ_SIZE = 64

var squareNumber

func setInSquare():
	position.x = int(position.x / SQ_SIZE) * SQ_SIZE + SQ_SIZE/2
	position.y = int(position.y / SQ_SIZE) * SQ_SIZE + SQ_SIZE/2

func getLegalSquares(board):
	pass

func _ready():
	setInSquare()
