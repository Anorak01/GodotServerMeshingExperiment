extends Node

var entities: Array[Entity] = [] # list of entities

var servers: Dictionary[int, WebSocketPeer] = {}

var players: Dictionary[int, WebSocketPeer] = {}

# entities will have id, players starting with p_

const X_BOUNDARY = 500

const PORT = 8080

func _ready() -> void:
	print("setting up server")
	$WebSocketServer.listen(PORT)
	print("start server called")

func _on_web_socket_server_client_connected(peer: WebSocketPeer, id: int, protocol: String) -> void:
	print("client connected, ID: " + str(id) + " protocol: " + protocol)

func _on_web_socket_server_client_disconnected(peer: WebSocketPeer, id: int, was_clean_close: bool) -> void:
	print("client disconnected, ID: " + str(id))

func _on_web_socket_server_data_received(peer: WebSocketPeer, id: int, message: Variant, is_string: bool) -> void:
	#print("got data, ID: " + str(id) + " message: " + str(message))
	return
	if is_string:
		var msg: String = message
		print(msg)
		return

func _on_web_socket_server_server_listen() -> void:
	print("replication server started")


func _on_web_socket_server_text_received(peer: WebSocketPeer, id: int, message: String) -> void:
	var e: Message = SimpleJsonClassConverter.json_string_to_class(message)
	#print(typeof(e))
	#print(e.get_type())
	match e.get_type(): 
		Msg.SRV_HELLO:
			if !servers.has(id):
				servers[id] = peer
			else:
				peer.close(1000, "why u bullshittin")
			
		Msg.PLR_HELLO:
			players[id] = peer
			# TODO: spawn player entity and assign it to the authority
			var player_entity: Entity = Entity.new()
			player_entity.id = "p_" + str(id)
			player_entity.authority = servers.keys()[0] # only the id here
			player_entity.x = 0
			player_entity.y = 0
			entities.append(player_entity)
			print("hello from player " + str(id) + ", created new entity")
			print("sending entity to authoritative server")
			var msg = AuthorityChangeMessage.create(true, player_entity)
			#var str_msg = Util.msg2str(msg)
			var str_msg = SimpleJsonClassConverter.class_to_json_string(msg)
			print(str_msg)
			servers[player_entity.authority].send_text(str_msg)
			players[id].send_text(Util.msg2str(EntityUpdateMessage.create(player_entity.id, player_entity)))
			
		Msg.PLR_MOVE:
			if id in players:
				# TODO: continue here
				var entity = get_entity("p_"+str(id))
				# send the move to the authoritative server
				servers[entity.authority].send_text(message)
				
			else: # player tried to move before sending hello
				print("player " + str(id) + "tried to move before saying hello")
		
		Msg.ENTITY_UPDATE:
			#print("entity update from server")
			var ee: EntityUpdateMessage = e
			var x = get_entity(ee.entity_id)
			if (x.authority == id): # only update the entity if it comes from the correct server
				x.x = ee.entity.x
				x.y = ee.entity.y
				# build in some sort of server authority change here based on coords
				if (x.x > X_BOUNDARY):
					if x.authority == servers.keys()[0]:
						print("changing autority to s1")
						x.authority = servers.keys()[1]
						servers[id].send_text(Util.msg2str(AuthorityChangeMessage.create(false, x)))
						servers[servers.keys()[1]].send_text(Util.msg2str(AuthorityChangeMessage.create(true, x)))
				else:
					if x.authority == servers.keys()[1]:
						print("changing autority to s0")
						x.authority = servers.keys()[0]
						servers[id].send_text(Util.msg2str(AuthorityChangeMessage.create(false, x)))
						servers[servers.keys()[0]].send_text(Util.msg2str(AuthorityChangeMessage.create(true, x)))
				
				# actually send the updated entities to players
				update_players(x)
				
		Msg.AUTHORITY_CHANGE:
			print("tis sum bullshit, why is authority change coming to the replication?")

func update_players(entity: Entity):
	for key in players.keys():
		players[key].send_text(Util.msg2str(EntityUpdateMessage.create(entity.id, entity)))
		

func get_entity(id: String) -> Entity:
	for entity in entities:
		if entity.id == id:
			return entity
	return null
	
func update_entity(entity: Entity) -> void:
	for e in entities:
		if e.id == entity.id:
			e.authority = entity.authority
			e.x = entity.x
			e.y = entity.y
