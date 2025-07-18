extends Message
class_name AuthorityChangeMessage

@export var add: bool # if this message adds the entity or removes it from servers entity pool
@export var entity: Entity

static func create(add: bool, entity: Entity) -> AuthorityChangeMessage:
	var message = AuthorityChangeMessage.new().type(Msg.AUTHORITY_CHANGE)
	message.add = add
	message.entity = entity
	return message
