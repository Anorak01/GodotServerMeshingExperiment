extends Node2D

const PORT = 8080
const IPADDR = "localhost"

var connection_established = false
var trying_connect = true

var entities: Dictionary[String, SpriteEntity] = {}

func _ready() -> void:
	print("connecting")
	$WebSocketClient.url_server = "ws://" + IPADDR + ":" + str(PORT)
	var err = await $WebSocketClient.connect_to_server()
	print("ERROR: " + str(err))



func _on_web_socket_client_text_received(peer: WebSocketPeer, message: Variant) -> void:
	print("got data: " + str(message))
	var e: Message = SimpleJsonClassConverter.json_string_to_class(message)
	
	match e.get_type(): 		
		Msg.ENTITY_UPDATE:
			var ee: EntityUpdateMessage = e
			if ee.entity_id in entities.keys():
				update_entity(ee.entity)
			else:
				spawn_entity(ee.entity)

func spawn_entity(entity: Entity) -> void:
	var ent: SpriteEntity = SpriteEntity.from_entity(entity)
	entities[ent.id] = ent
	self.add_child(ent)

func update_entity(entity: Entity) -> void:
	var ent: SpriteEntity = entities[entity.id]
	ent.authority = entity.authority
	ent.x = entity.x
	ent.y = entity.y


func _on_web_socket_client_connection_established(peer: WebSocketPeer, protocol: String) -> void:
	print("sending hello")
	$WebSocketClient.send_text(Util.msg2str(Message.new().type(Msg.PLR_HELLO)))
