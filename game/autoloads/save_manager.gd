extends Node

# SaveManager - Autoload for saving.
# nodes that can persist should define two functions:
#  save() -> Dictionary
#       Saves whatever data is necessary for that node
#       Must have a SaveType enum key
#       There are more keys that must be defined for the corresponding save type, 
#           they are defined as the corresponding enums.

#   load(dictionary) -> void
#       each node is responsible for loading its data. 

const DEFAULT_PATH := "user://savegame.save"
const PERSIST_GROUP := "persist"


enum SaveType {
	RELOAD, # delete node and reinstantiate it
	NO_RELOAD # laod data onto autoload - dont delete
}

enum SaveKeys_RELOAD {
	FILENAME,
	PARENT,
}
enum SaveKeys_NO_RELOAD {
	PATH,
}

# Each savable object is saved as a single line in a file.
func save_game(path := DEFAULT_PATH) -> void:
	print("Saving game...")
	var f := FileAccess.open(path, FileAccess.WRITE)
	for node in get_tree().get_nodes_in_group(PERSIST_GROUP):
		if not node.has_method("save"):
			push_error("Save Manager: persist node should define a save function!")
		if not node.has_method("load"):
			push_error("Save Manager: persist node should define a load function!")

		var payload: Dictionary = node.save()
		
		# get the save type
		if !payload.has("save_type"):
			push_error("Save Manager: persist node should define a save_type!")

		f.store_line(JSON.stringify(payload))
		print("Saved " + str(node.name))
	print("Save finished!")


func load_game(path := DEFAULT_PATH) -> void:
	print("Loading game...")
	if not FileAccess.file_exists(path):
		return


	for node in get_tree().get_nodes_in_group(PERSIST_GROUP):
		if node.get("save_type") == SaveType.RELOAD:
			node.queue_free()
			await node.tree_exited
		
	# await get_tree().process_frame

	var f = FileAccess.open(path, FileAccess.READ)
	while f.get_position() < f.get_length():
		var data: Dictionary = JSON.parse_string(f.get_line())
		print(data)

		if typeof(data) != TYPE_DICTIONARY:
			push_error("Save Manager: each line in the save file should represent a dictionary.")

		if not data:
			print("Save Manager: data not found on line " + str(f.get_position()) + " when loading")
			continue

		match data.get("save_type") as SaveType:
			SaveType.RELOAD:
				var filename: String = data[str(SaveKeys_RELOAD.FILENAME)] # path in editor
				var parent_path: String = data[str(SaveKeys_RELOAD.PARENT)]
				if not filename:
					push_error("Save Manager: filename not defined for RELOAD node")
				if not parent_path:
					push_error("Save Manager: parent path not defined for RELOAD node")

				# add the node to the scene
				var inst = load(filename).instantiate()
				var parent = get_node(parent_path)
				parent.add_child(inst)

					
				inst.load(data)

			SaveType.NO_RELOAD:
				var autoload_path = data[str(SaveKeys_NO_RELOAD.PATH)]

				if not autoload_path:
					push_error("Save Manager: need to define a path for the autoload")

				var node = get_node(autoload_path)

				print(node)

				node.load(data)

	print("Load finished!")
