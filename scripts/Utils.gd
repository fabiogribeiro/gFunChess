extends Object

class_name Utils

const SQ_SIZE = 64

static func intCoordsToSquare(x, y):
	return y * 8 + x

static func squareToCoordsInt(n):
	return [n%8, n/8]

static func coordsToSquare(x, y):
	return int(y / SQ_SIZE) * 8 + int(x / SQ_SIZE)

static func squareToCoords(n):
	return Vector2((n%8)*SQ_SIZE + SQ_SIZE/2, int(n/8)*SQ_SIZE + SQ_SIZE/2)
