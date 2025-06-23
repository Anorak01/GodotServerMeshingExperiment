extends Message
class_name EntityUpdateMessage

const e = preload("res://entity.gd")

var entity_id: String
var entity: e.Entity

static func create(entity_id: String, entity: e.Entity) -> EntityUpdateMessage:
	var message: EntityUpdateMessage = EntityUpdateMessage.new().type(Msg.ENTITY_UPDATE)
	message.entity_id = entity_id
	message.entity = entity
	return message
