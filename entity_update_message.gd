extends Message
class_name EntityUpdateMessage

var entity_id: String
var entity: Entity

static func create(entity_id: String, entity: Entity) -> EntityUpdateMessage:
	var message: EntityUpdateMessage = EntityUpdateMessage.new().type(Msg.ENTITY_UPDATE)
	message.entity_id = entity_id
	message.entity = entity
	return message
