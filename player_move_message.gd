extends Message
class_name PlayerMoveMessage

var id: String # player entity id
var dir: Vector2 # direction in which to move the entity (for now, later can be keypress thing)

static func create(id: String, dir: Vector2) -> PlayerMoveMessage:
	var message: PlayerMoveMessage = PlayerMoveMessage.new().type(Msg.PLR_MOVE)
	message.id = id
	message.dir = dir
	return message
