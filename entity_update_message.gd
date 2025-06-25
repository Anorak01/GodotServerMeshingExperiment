extends Message
class_name EntityUpdateMessage

@export var entity_id: String
@export var entity: Entity

static func create(entity_id: String, entity: Entity) -> EntityUpdateMessage:
	var message: EntityUpdateMessage = EntityUpdateMessage.new().type(Msg.ENTITY_UPDATE)
	message.entity_id = entity_id
	message.entity = entity
	return message
