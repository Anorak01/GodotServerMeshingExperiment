extends Entity
class_name SpriteEntity

func _ready() -> void:
	self.position.x = self.x
	self.position.y = self.y

func _on_update_pos() -> void:
	self.position.x = self.x
	self.position.y = self.y

static func from_entity(entity: Entity) -> SpriteEntity:
	var spr_entity = SpriteEntity.new()
	spr_entity.authority = entity.authority
	spr_entity.id = entity.id
	spr_entity.x = entity.x
	spr_entity.y = entity.y
	return spr_entity
