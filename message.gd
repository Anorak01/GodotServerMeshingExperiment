extends Node
class_name Message

@export var _type: int

func type(type: int) -> Message:
	self._type = type
	return self

func get_type() -> int:
	return self._type
