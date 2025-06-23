extends Node
class_name Util

static func msg2str(message: Message) -> String:
	return SimpleJsonClassConverter.class_to_json_string(message)
