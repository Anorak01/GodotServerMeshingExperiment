extends Node2D
class_name SpriteEntity

signal update_pos

var authority: int
var id: String
var x: int:
	set(val):
		x = val
		update_pos.emit()
var y: int:
	set(val):
		y = val
		update_pos.emit()


func _ready() -> void:
	self.position.x = self.x
	self.position.y = self.y

func _on_update_pos() -> void:
	self.position.x = self.x
	self.position.y = self.y

static func from_entity(entity: Entity) -> SpriteEntity:
	var x = load("res://client/SpriteEntity.tscn")#SpriteEntity.new()
	var spr_entity = x.instantiate()
	
	spr_entity.authority = entity.authority
	spr_entity.id = entity.id
	spr_entity.x = entity.x
	spr_entity.y = entity.y
	return spr_entity
