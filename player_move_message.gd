extends Message
class_name PlayerMoveMessage

@export var id: String # player entity id
@export var dir: Vector2 # direction in which to move the entity (for now, later can be keypress thing)

static func create(id: String, dir: Vector2) -> PlayerMoveMessage:
	var message: PlayerMoveMessage = PlayerMoveMessage.new().type(Msg.PLR_MOVE)
	message.id = id
	message.dir = dir
	return message
