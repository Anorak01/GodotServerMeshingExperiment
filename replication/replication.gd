extends Node

var entities = []

var servers = []

var players = []

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
	print("got data, ID: " + str(id) + " message: " + str(message))
	return
	if is_string:
		var msg: String = message
		print(msg)
		return
	#if typeof(message) == Variant.Type.TYPE_PACKED_BYTE_ARRAY:
		#var mess: PackedByteArray = message
		#var x: Message = bytes_to_var_with_objects(mess)
		#print(x.type)
		#print(mess.get_string_from_ascii())



func _on_web_socket_server_server_listen() -> void:
	print("server started")


func _on_web_socket_server_text_received(peer: WebSocketPeer, id: int, message: String) -> void:
	#var x = JSON.parse_string(message)
	##print(x)
	#print(typeof(x))
	#print(x.type)
	var e: Message = SimpleJsonClassConverter.json_string_to_class(message)
	print(typeof(e))
	print(e.get_type())
	match e.get_type(): 
		Msg.SRV_HELLO:
			servers.append(id)
			
		Msg.PLR_HELLO:
			players.append(id)
			# TODO: spawn player entity and assign it to them
			
		Msg.PLR_MOVE:
			if id in players:
				# TODO: continue here
