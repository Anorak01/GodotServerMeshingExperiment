extends Node
class_name Entity

signal update_pos

@export var authority: int
@export var id: String
@export var x: float:
	set(val):
		x = val
		update_pos.emit()
@export var y: float:
	set(val):
		y = val
		update_pos.emit()
