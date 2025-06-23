extends Node

func _ready():
	var args = OS.get_cmdline_args()
	
	print(args)
	await get_tree().process_frame

	if "server" in args:
		print("Starting server scene...")
		get_tree().change_scene_to_file("res://server/Server.tscn")
	elif "replication" in args:
		print("Starting replication scene...")
		get_tree().change_scene_to_file("res://replication/Replication.tscn")
	elif "client" in args:
		print("Starting client scene...")
		get_tree().change_scene_to_file("res://client/Client.tscn")
	else:
		print("No mode specified. Use 'server' or 'client'.")
		get_tree().quit()
