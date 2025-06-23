extends Node
class_name Msg
enum {
	SRV_HELLO, # sent from server to assign self connection as server
	PLR_HELLO, # sent from player to assign self connection as client
	PLR_MOVE, # sent from player as player control keybind, sent to server from replication to process
	ENTITY_UPDATE, # sent from server to replication, replication to player to update entities
	AUTHORITY_CHANGE # sent from replication to servers, used when changing entity servers
}
