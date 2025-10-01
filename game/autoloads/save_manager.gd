extends Node

# SaveManager - Autoload for saving.
# nodes that can persist should define two functions:
#  save() -> Dictionary
#       Saves whatever data is necessary for that node
#   load(dictionary) -> void
#       each node is responsible for loading its data. 

const DEFAULT_PATH := "user://savegame.save"
const PERSIST_GROUP := "persist"


enum SaveType {
    RELOAD, # delete node and reinstantiate it
    AUTOLOAD # laod data onto autoload - dont delete
}

# Each savable object is saved as a single line in a file.
func save_game(path := DEFAULT_PATH) -> void:
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


func load_game(path := DEFAULT_PATH) -> void:
    if not FileAccess.file_exists(path):
        return


    for node in get_tree().get_nodes_in_group(PERSIST_GROUP):
        if node.get("save_type") == SaveType.RELOAD:
            node.queue_free()
            await node.tree_exited
        
    # await get_tree().process_frame

    var f = FileAccess.open(path, FileAccess.READ)
    while f.get_position() < f.get_length():
        var data = JSON.parse_string(f.get_line())

        if typeof(data) != TYPE_DICTIONARY:
            push_error("Save Manager: each line in the save file should represent a dictionary.")

        if not data:
            print("Save Manager: data not found on line " + str(f.get_position()) + " when loading")
            continue


        match data.get("save_type"):
            SaveType.RELOAD:
                var filename: String = data["filename"] # path in editor
                var parent_path: String = data["parent"]
                if not filename:
                    push_error("Save Manager: filename not defined for RELOAD node")
                if not parent_path:
                    push_error("Save Manager: parent path not defined for RELOAD node")

                # add the node to the scene
                var inst = load(filename).instantiate()
                var parent = get_node(parent_path)
                parent.add_child(inst)

                    
                inst.load(data)

            SaveType.AUTOLOAD:
                var autoload_path: String = data["path"]
                if not autoload_path:
                    push_error("Save Manager: need to define a path for the autoload")

                var node = get_node(autoload_path)

                node.load(data)
