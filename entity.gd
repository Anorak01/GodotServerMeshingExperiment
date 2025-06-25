extends Node
class_name Entity

signal update_pos

var authority: int
var id: String
var x: int:
	set(val):
		x = val
		update_pos.emit()
var y: int:
	set(val):
		y = val
		update_pos.emit()
