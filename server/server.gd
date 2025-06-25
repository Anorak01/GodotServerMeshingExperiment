extends Node

const PORT = 8080
const IPADDR = "localhost"

var connection_established = false
var trying_connect = true

var entities: Array[Entity] = []

var input_queue: Array[PlayerMoveMessage] = [] # array of player move messages to be processed next physics frame

func _ready() -> void:
	$WebSocketClient.url_server = "ws://" + IPADDR + ":" + str(PORT)
	var err = await $WebSocketClient.connect_to_server()
	print("ERROR: " + str(err))

func _process(delta: float) -> void:
	#if connection_established:
		#$WebSocketClient.send("hello".to_ascii_buffer())

	if !connection_established and !trying_connect:
		trying_connect = true
		print("reconnecting")
		var err = $WebSocketClient.connect_to_server()
		print("ERROR: " + str(err))
		$Timer.start(5)

func _on_web_socket_client_connection_closed(was_clean_close: bool) -> void:
	connection_established = false

func _on_timer_timeout() -> void:
	trying_connect = false


func _physics_process(delta: float) -> void:
	for input in input_queue:
		print(input.id)
		var entity = get_entity(input.id)
		entity.x += (input.dir.x * delta * 100)
		entity.y += (input.dir.y * delta * 100)
		# send entity update
		var msg = Util.msg2str(EntityUpdateMessage.create(entity.id, entity))
		print(msg)
		$WebSocketClient.send_text(msg)
	input_queue.clear()

func _on_web_socket_client_connection_established(peer: WebSocketPeer, protocol: String) -> void:
	connection_established = true
	var x = Message.new().type(Msg.SRV_HELLO)
	var e = SimpleJsonClassConverter.class_to_json_string(x)
	print(e)
	$WebSocketClient.send_text(e)

func get_entity(id: String) -> Entity:
	for entity in entities:
		if entity.id == id:
			return entity
	return null


func _on_web_socket_client_text_received(peer: WebSocketPeer, message: Variant) -> void:
	print("got data: " + str(message))
	var e: Message = SimpleJsonClassConverter.json_string_to_class(message)
	
	match e.get_type(): 
		Msg.AUTHORITY_CHANGE:
			var ee: AuthorityChangeMessage = e
			print(ee.add)
			if ee.add:
				print(ee.entity)
				print(ee.entity.id)
				entities.append(ee.entity)
				print("appending entity")
				for i in entities:
					print(i.id)
			else:
				entities.erase(get_entity(ee.entity.id))
		
		Msg.PLR_MOVE:
			var ee: PlayerMoveMessage = e
			print("moving player")
			input_queue.append(e)
