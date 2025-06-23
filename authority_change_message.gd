extends Message
class_name AuthorityChangeMessage

const e = preload("res://entity.gd")

var add: bool # if this message adds the entity or removes it from servers entity pool
var entity: e.Entity

static func create(add: bool, entity: e.Entity) -> AuthorityChangeMessage:
	var message = AuthorityChangeMessage.new().type(Msg.AUTHORITY_CHANGE)
	message.add = add
	message.entity = entity
	return message
